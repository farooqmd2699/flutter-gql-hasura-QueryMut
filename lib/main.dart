import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'dart:ui';

import 'mut.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
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

    return MaterialApp(
      home: GraphQLProvider(
        child: MyHomePage(),
        client: client,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String no;
  String query = '''
  query MyQuery {
  cse {
    age
    name
    no
  }
}

  ''';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Parsing data using GraphQL',
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'mutation_page',
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) {
                  return MutationPage();
                })));
              },
            ),
          ],
        ),
        body: Query(
          options: QueryOptions(
            documentNode: gql(query),
          ),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            if (result.data == null) {
              return Center(
                  child: Text(
                "Loading...",
                style: TextStyle(fontSize: 20.0),
              ));
            } else {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(5),
                    onTap: () => {},
                    title: Text(result.data['cse'][index]['name']),
                    //leading: Image.network(
                    //  result.data['characters']['results'][index]['image']),
                    subtitle: Text(result.data['cse'][index]['no'].toString()),
                    // title: Text(result.data["languages"]["edges"][index]["node"]
                    //     ['name']),
                    // trailing: Text(result.data["languages"]["edges"][index]
                    //     ["node"]['saveFormat']),
                  );
                },
                itemCount: result.data['cse'].length,
                //itemCount: result.data["languages"]["edges"].length,
              );
            }
          },
        ),
      ),
    );
  }
}
