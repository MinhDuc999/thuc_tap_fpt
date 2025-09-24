import 'package:btcat_di_getit/config/injection.dart';
import 'package:btcat_di_getit/presentations/cat/cat_notifier.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _catNotifier = getIt<CatNotifier>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _catNotifier.loadCats();
    });
  }

  @override
  void dispose() {
    _catNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Cats',
          style: TextStyle(
            fontSize: 32,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _catNotifier.loadCats,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _catNotifier.isLoading,
        builder: (context, loading, _) {
          if (loading) return const Center(child: CircularProgressIndicator());
          return ValueListenableBuilder(
            valueListenable: _catNotifier.errorMessage,
            builder: (context, error, _) {
              if (error != null) return Center(child: Text("Lỗi $error"));
              return StreamBuilder(
                stream: _catNotifier.catStream,
                initialData: _catNotifier.cachedCats,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Lỗi ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text("No data"));
                  }

                  final cats = snapshot.data!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    padding: const EdgeInsets.all(8),
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  cats[index].url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${cats[index].width}x${cats[index].height}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
