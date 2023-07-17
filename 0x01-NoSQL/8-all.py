#!/usr/bin/env python3
""" List all documents in a collection """


def list_all(mongo_collection):
    """ Lists all documents """
    document_list = []

    if not mongo_collection.count_documents({}):
        return document_list

    for doc in mongo_collection.find():
        document_list.append(doc)
    return document_list
