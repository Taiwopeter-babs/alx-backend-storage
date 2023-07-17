#!/usr/bin/env python3
""" List all documents in a collection """


def update_topics(mongo_collection, topic: list) -> list:
    """ Updates a document """

    documents = []
    for school in mongo_collection.find({"topic": topic}):
        documents.append(school)
