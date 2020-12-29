import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_bloc_repository_di/bloc/post_bloc.dart';
import 'package:posts_bloc_repository_di/data/repository/post_repository.dart';
import 'package:posts_bloc_repository_di/tracing_bloc.dart';

main() {
  Bloc.observer = TracBloc();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => PostBloc(PostRepositoryImpl())..add(FetchPosts()),
      child: Home(),
    ));
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Posts'),
      ),
      body: Center(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return CircularProgressIndicator();
            } else if (state is PostLoaded) {
              return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, i) {
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(state.posts[i].title),
                        subtitle: Text(state.posts[i].id.toString()),
                      ),
                    );
                  });
            } else if (state is PostError) {
              return Text(state.message);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
