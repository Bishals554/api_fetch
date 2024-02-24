import 'package:api_fetch/model/data_model.dart';
import 'package:api_fetch/provider/data_provider.dart';
import 'package:api_fetch/provider/search_provider.dart';
import 'package:api_fetch/provider/sort_provider.dart';
import 'package:api_fetch/src/widgets/custom_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userData = ref.watch(userDataProvider);
    textController.text = ref.watch(searchQueryProvider);
    final sortingOrder = ref.watch(sortingOrderProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: textController,
                onChanged: (value) {
                  ref
                      .read(searchQueryProvider.notifier)
                      .update((state) => state = value);
                },
                onEditingComplete: () {},
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                        textController.clear();
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
            Consumer(
              builder: (context, ref, child) {
                final sortingOrder = ref.watch(sortingOrderProvider);
                return PopupMenuButton(
                  position: PopupMenuPosition.under,
                  icon: Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('Default'),
                        value: 'Default',
                      ),
                      PopupMenuItem(
                        child: Text('Ascending'),
                        value: 'Ascending',
                      ),
                      PopupMenuItem(
                        child: Text('Descending'),
                        value: 'Descending',
                      ),
                    ];
                  },
                  onSelected: (value) {
                    ref.read(sortingOrderProvider.notifier).state = value;
                  },
                );

                // GestureDetector(
                //   onTap: () {
                // ref.read(sortingOrderProvider.notifier).update((state) {
                //   return state == 'Ascending' ? 'Descending' : 'Ascending';
                // });
                //   },
                //   child: Icon(
                //     Icons.sort,
                //     color: Colors.white,
                //   ),
                //   // Row(
                //   //   children: [
                //   //     const RotatedBox(
                //   //       quarterTurns: 1,
                //   //       child: Icon(
                //   //         Icons.compare_arrows,
                //   //         color: Colors.white,
                //   //       ),
                //   //     ),
                //   //     Text(
                //   //       sortingOrder,
                //   //       style: const TextStyle(
                //   //           fontSize: 12, color: Colors.white),
                //   //     )
                //   //   ],
                //   // )
                // );
              },
            ),
          ],
        ),
      ),
      body: userData.when(
        data: (userData) {
          List<UserData?> userDataList =
              userData!.data!.map((element) => element).toList();
          if (sortingOrder == 'Ascending') {
            userDataList
                .sort((a, b) => a!.employeeName!.compareTo(b!.employeeName!));
          } else if (sortingOrder == 'Descending') {
            userDataList
                .sort((a, b) => b!.employeeName!.compareTo(a!.employeeName!));
          }
          final filteredList = userDataList.where((element) => element!
              .employeeName!
              .toLowerCase()
              .contains(textController.text));
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return CustomList(
                id: filteredList.elementAt(index)!.id ?? 0,
                employeeName: filteredList.elementAt(index)!.employeeName ?? '',
                employeeSalary:
                    filteredList.elementAt(index)!.employeeSalary ?? 0,
                employeeAge: filteredList.elementAt(index)!.employeeAge ?? 0,
                profileImage: filteredList.elementAt(index)!.profileImage ?? '',
              );
            },
          );
        },
        error: (error, stackTrace) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString()),
            ElevatedButton(
              onPressed: () async {
                try {
                  userData = ref.refresh(userDataProvider);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to fetch data: $error')),
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
