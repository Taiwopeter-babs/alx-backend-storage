#!/usr/bin/env python3
""" List all documents in a collection """


def update_topics(mongo_collection, topic: list) -> list:
    """ Updates a document """

    return mongo_collection.find({"topic": topic})
