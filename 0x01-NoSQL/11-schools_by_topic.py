#!/usr/bin/env python3
""" List all documents in a collection """


def update_topics(mongo_collection, topic: list) -> list:
    """ Find documents that match a criterium """

    documents = []
    for school in mongo_collection.find({"topics": {"$in": [topic]}}):
        documents.append(school)
    return documents
