import 'package:api_fetch/model/data_model.dart';
import 'package:api_fetch/provider/data_provider.dart';
import 'package:api_fetch/provider/search_provider.dart';
import 'package:api_fetch/src/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController searchController = TextEditingController();
    final userData = ref.watch(userDataProvider);
    final searchQuery = ref.watch(searchQueryProvider.notifier).state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.6,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              print('change');
              ref.read(searchQueryProvider.notifier).state = value;
              // ref.refresh(searchQueryProvider);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: GestureDetector(
                  onTap: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                    searchController.clear();
                    Future.delayed(const Duration(milliseconds: 1), () {
                      return ref.refresh(searchQueryProvider);
                    });
                  },
                  child: const Icon(
                    Icons.clear_outlined,
                    size: 20,
                  )),
              fillColor: Colors.grey.shade200,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
      body: userData.when(
          data: (userData) {
            List<UserData?> userDataList =
                userData!.data!.map((element) => element).toList();
            final filteredList = userDataList.where((element) =>
                element!.employeeName!.toLowerCase().contains(searchQuery));
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return CustomList(
                  id: filteredList.elementAt(index)!.id ?? 0,
                  employeeName:
                      filteredList.elementAt(index)!.employeeName ?? '',
                  employeeSalary:
                      filteredList.elementAt(index)!.employeeSalary ?? 0,
                  employeeAge: filteredList.elementAt(index)!.employeeAge ?? 0,
                  profileImage:
                      filteredList.elementAt(index)!.profileImage ?? '',
                );
              },
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
