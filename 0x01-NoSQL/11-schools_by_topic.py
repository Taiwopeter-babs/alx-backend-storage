#!/usr/bin/env python3
""" List all documents in a collection """


def update_topics(mongo_collection, topic: list) -> list:
    """ Find documents that match a criterium """

    return mongo_collection.find({"topics": topic})
