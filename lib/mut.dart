import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MutationPage extends StatelessWidget {
  //const MutationPage({ Key key }) : super(key: key);
  static HttpLink httpLink = HttpLink(
    uri: 'https://immense-pug-91.hasura.app/v1/graphql',
    // headers: {
    //   'X-Parse-Application-Id': kParseApplicationId,
    //   'X-Parse-Client-Key': kParseClientKey,
    // }, //getheaders()
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    ),
  );

  @override
  Widget build(BuildContext context) {
    //Navigator.pop(context, true);
    return GraphQLProvider(
      child: Homepage(),
      client: client,
    );
  }
}

class Homepage extends StatelessWidget {
  // const Homepage({Key key}) : super(key: key);
  TextEditingController nameController = new TextEditingController();
  TextEditingController noController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  String query2 = r'''
  mutation insertcse($name:String!,$no:String!,$age:String!) {
  insert_cse_one(object: {age: $age, name: $name, no: $no}) {
    name
    no
    age
  }
}

  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mutation"),
      ),
      body: Mutation(
        options: MutationOptions(documentNode: gql(query2)),
        builder: (RunMutation insert, QueryResult result) {
          return Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "name"),
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(hintText: "no"),
                controller: noController,
              ),
              TextField(
                decoration: InputDecoration(hintText: "age"),
                controller: ageController,
              ),
              RaisedButton(
                child: Text("submit"),
                onPressed: () {
                  insert(<String, dynamic>{
                    "name": nameController.text,
                    "no": noController.text,
                    "age": ageController.text,
                  });
                },
              ),
              Text("result:\n ${result.data?.data?.toString()}"),
            ],
          );
        },
      ),
    );
  }
}
