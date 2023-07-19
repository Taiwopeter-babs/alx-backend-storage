#!/usr/bin/env python3
"""Writing strings to redis"""
from functools import wraps
import redis
from typing import Callable, Optional, Union
from uuid import uuid4


def count_calls(method: Callable) -> Callable:
    """decorator function to count calls to methods in Cache class"""

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """increments the counter of the method name when it's called"""
        # args[0] is the first argument of the wrapped function `method`
        # args[0] = self
        key = method.__qualname__
        self._redis.incr(key, 1)
        return method(self, *args, **kwargs)
    return wrapper


def call_history(method: Callable) -> Callable:
    """decorator function to add to list in redis"""
    input_list = "{}:inputs".format(method.__qualname__)
    output_list = "{}:outputs".format(method.__qualname__)

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """increments the counter of the method name when it's called"""

        self._redis.rpush(input_list, str(args))
        # execute the wrapped function
        return_key = method(self, *args, **kwargs)
        # store the output in the output list
        self._redis.rpush(output_list, return_key)
        return return_key
    return wrapper


def replay(func: Optional[Callable] = None) -> None:
    """displays the history of a function"""
    redis_cli = redis.Redis()
    if func:
        call_times: Union[int, bytes, None]
        func_in_list: str
        func_out_list: str

        try:
            func_keyname = func.__qualname__
            func_in_list = "{}:inputs".format(func_keyname)
            func_out_list = "{}:outputs".format(func_keyname)
        except AttributeError:
            return

        # get times function was called
        call_times = redis_cli.get(func_keyname)
        if call_times is None:
            call_times = 0
        else:
            call_times = int(call_times.decode())

        # get input list
        input_list = redis_cli.lrange(func_in_list, 0, -1)
        out_list = redis_cli.lrange(func_out_list, 0, -1)
        combined_list = zip(input_list, out_list)

        for inp, out in list(combined_list):
            print("{}(*{}) -> {}".format(func_keyname, inp.decode(),
                                         out.decode()))
    return


class Cache:
    """A class for caching in redis"""

    def __init__(self):
        self._redis = redis.Redis()
        self._redis.flushdb()

    @call_history
    @count_calls
    def store(self, data: Union[str, int, float, bytes]) -> str:
        """sets a value to a key in redis and returns the key"""
        new_key = str(uuid4())
        self._redis.set(new_key, data)
        return new_key

    def get(self, key: str,
            fn: Optional[Callable] = None) -> Union[int, str, bytes, None]:
        """
        gets the value of a key and uses
        a function to convert from bytes to python object
        """
        ret_val = self._redis.get(key)
        # return the value if conversion function is None
        if not fn:
            return ret_val
        if ret_val:
            if fn is int:
                return self.get_int(ret_val)
            else:
                to_convert = ret_val.decode('utf-8')
                return self.get_str(to_convert)

    def get_int(self, data: bytes) -> int:
        """returns an integer"""
        return int(data)

    def get_str(self, data: str) -> str:
        return data
