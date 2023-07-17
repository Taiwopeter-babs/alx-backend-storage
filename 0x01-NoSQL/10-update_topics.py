#!/usr/bin/env python3
""" List all documents in a collection """


def update_topics(mongo_collection, name: str, topics: list):
    """ Updates a document """

    return mongo_collection.update_many(
        {"name": name},
        {"$set": {"topics": topics}}
    )
