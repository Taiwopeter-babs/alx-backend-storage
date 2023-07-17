#!/usr/bin/env python3
""" List all documents in a collection """


def insert_school(mongo_collection, **kwargs):
    """ Inserts a new document in a collection """
    doc_id = mongo_collection.insert_one(kwargs).inserted_id
    return doc_id
