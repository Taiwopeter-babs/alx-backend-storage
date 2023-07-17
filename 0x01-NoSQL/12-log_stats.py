#!/usr/bin/env python3
"""Show statistics about nginx logs in mongodb"""
from pymongo import MongoClient


METHODS = ["GET", "POST", "PUT", "PATCH", "DELETE"]


def show_nginx_stats(mongo_collection, method_option=None):
    """Show formatted nginx stats in mongo db
    printing stats w.r.t the methods in METHODS
    """

    num_of_docs = mongo_collection.count_documents({})

    # print number of logs
    print("{} logs".format(num_of_docs))

    print('Methods:')

    for method in METHODS:
        method_count = mongo_collection.count_documents(
            {"method": {"$in": [method]}}
        )
        print("\tmethod {}: {}".format(method, method_count))

    status_path_check = mongo_collection.count_documents({"path": "/status"})
    print(f"{status_path_check} status check")


if __name__ == '__main__':
    nginx_collection = MongoClient('mongodb://127.0.0.1:27017').logs.nginx
    show_nginx_stats(nginx_collection)
