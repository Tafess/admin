// ignore_for_file: prefer_const_constructors

import 'package:admin/constants/routes.dart';
import 'package:admin/models/catagory_model.dart';
import 'package:admin/provider/app_provider.dart';
import 'package:admin/widgets/edit_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SingleCategoryItem extends StatefulWidget {
  final CategoryModel singleCategory;
  final int index;
  const SingleCategoryItem(
      {super.key, required this.singleCategory, required this.index});

  @override
  State<SingleCategoryItem> createState() => _SingleCategoryItemState();
}

class _SingleCategoryItemState extends State<SingleCategoryItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  child: Image.network(
                    widget.singleCategory.image,
                    scale: 12,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0.2,
            child: Row(
              children: [
                IgnorePointer(
                  ignoring: isLoading,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await appProvider
                          .deleteCategoryFromFirebase(widget.singleCategory);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Routes.instance.push(
                        widget: EditCategory(
                            categoryModel: widget.singleCategory,
                            index: widget.index),
                        context: context);
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
