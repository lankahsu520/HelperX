//snippet-sourcedescription:[GetItem.cpp demonstrates how to retrieve an item from an Amazon DynamoDB table.]
//snippet-keyword:[AWS SDK for C++]
//snippet-keyword:[Code Sample]
//snippet-service:[Amazon DynamoDB]
//snippet-sourcetype:[full-example]
//snippet-sourcedate:[11/30/2021]
//snippet-sourceauthor:[scmacdon - aws]


/*
   Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
   SPDX-License-Identifier: Apache-2.0
*/

//snippet-start:[dynamodb.cpp.get_item.inc]
#include <aws/core/Aws.h>
#include <aws/core/utils/Outcome.h> 
#include <aws/dynamodb/DynamoDBClient.h>
#include <aws/dynamodb/model/AttributeDefinition.h>
#include <aws/dynamodb/model/GetItemRequest.h>
#include <iostream>
//snippet-end:[dynamodb.cpp.get_item.inc]


/*
   Get an item from a DynamoDB table.

   To run this C++ code example, ensure that you have setup your development environment, including your credentials.
   For information, see this documentation topic:
   https://docs.aws.amazon.com/sdk-for-cpp/v1/developer-guide/getting-started.html
*/
int main(int argc, char** argv)
{
    const std::string USAGE = "\n"
        "Usage: get_item <tableName> <pk> <pkval> <sk> <skval>\n"
        "Where:\n"
        "    tableName - the Amazon DynamoDB table from which an item is retrieved (for example, Music). \n"
        "    pk - the key used in the Amazon DynamoDB table (for example, Artist). \n"
        "    pkval - the key value that represents the item to get (for example, Acme Band).\n"
        "    sk - the key used in the Amazon DynamoDB table (for example, SongTitle). \n"
        "    skval - the key value that represents the item to get (for example, Happy Day).\n";

    if (argc < 6)
    {
        std::cout << USAGE;
        return 1;
    }

    Aws::SDKOptions options;
    
    Aws::InitAPI(options);
    {
        const Aws::String table =  (argv[1]);
        const Aws::String key_pk  = (argv[2]);
        const Aws::String keyval_pk = (argv[3]);
        const Aws::String key_sk  = (argv[4]);
        const Aws::String keyval_sk = (argv[5]);
       
        // snippet-start:[dynamodb.cpp.get_item.code]
        Aws::Client::ClientConfiguration clientConfig;
        Aws::DynamoDB::DynamoDBClient dynamoClient(clientConfig);
        Aws::DynamoDB::Model::GetItemRequest req;

        // Set up the request.
        req.SetTableName(table);
        Aws::DynamoDB::Model::AttributeValue hashKey;
        hashKey.SetS(keyval_pk);
        req.AddKey(key_pk, hashKey);
        hashKey.SetS(keyval_sk);
        req.AddKey(key_sk, hashKey);
     
        // Retrieve the item's fields and values
        const Aws::DynamoDB::Model::GetItemOutcome& result = dynamoClient.GetItem(req);
        if (result.IsSuccess())
        {
            // Reference the retrieved fields/values.
            const Aws::Map<Aws::String, Aws::DynamoDB::Model::AttributeValue>& item = result.GetResult().GetItem();
            if (item.size() > 0)
            {
                // Output each retrieved field and its value.
                for (const auto& i : item)
                    std::cout << "Values: " << i.first << ": " << i.second.GetS() << std::endl;
            }
            else
            {
                std::cout << "No item found with the key " << key_pk << std::endl;
            }
        }
        else
        {
            std::cout << "Failed to get item: " << result.GetError().GetMessage();
        }
        // snippet-end:[dynamodb.cpp.get_item.code]
    }
    Aws::ShutdownAPI(options);
    return 0;
}