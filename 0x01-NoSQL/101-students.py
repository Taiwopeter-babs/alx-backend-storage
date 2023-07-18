#!/usr/bin/env python3
""" Sorts all students by average score """


def top_students(mongo_collection):
    """ sorts students by average score """
    return mongo_collection.aggregate([
        {"$project": {
            "name": "$name",
            "average_score": {"$avg": "$topics.score"}
        }
        },
        {"$sort":
            {"average_score": -1}
         }
    ])
