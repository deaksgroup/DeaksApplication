import 'package:deaksapp/providers/Hotel.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isSorting = false;
  bool isFiltering = false;
  List<String> Tags = ["Open", "Full ( Waiting List )", "Closed"];
  List<String> Hotels = ["RITZ CARLTON", "PARK ROYAL"];
  List<String> SelectedHotelList = [];
  List<String> SelectedTagsList = [];
  void openFilterDialogForTags() async {
    await FilterListDialog.display<String>(
      context,
      listData: Tags,
      hideSearchField: true,
      hideHeader: true,
      selectedListData: SelectedTagsList,
      choiceChipLabel: (tag) => tag,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (tag, query) {
        return tag!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          SelectedTagsList = List.from(list!);
          print(SelectedTagsList);
        });
        Navigator.pop(context);
      },
    );
  }

  void openFilterDialogForHotels() async {
    await FilterListDialog.display<String>(
      context,
      listData: Hotels,
      hideSearchField: true,
      hideHeader: true,
      selectedListData: SelectedHotelList,
      choiceChipLabel: (Hotel) => Hotel,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (Hotel, query) {
        return Hotel!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          SelectedHotelList = List.from(list!);
          print(SelectedHotelList);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            onChanged: (value) => null,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenWidth(10)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search Job",
                prefixIcon: Icon(Icons.search)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: (() {
                  setState(() {
                    if (isSorting) {
                      isSorting = false;
                    } else {
                      isFiltering = false;
                      isSorting = true;
                    }
                  });
                }),
                child: Text("Sort")),
            TextButton(
                onPressed: (() {
                  setState(() {
                    if (isFiltering) {
                      isFiltering = false;
                    } else {
                      isSorting = false;
                      isFiltering = true;
                    }
                  });
                }),
                child: Text("Filter By"))
          ],
        ),
        if (isSorting)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(.2)))),
            width: double.infinity,
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    "All Jobs",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Latest Jobs",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Hourly Pay",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Job Date",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Morning TO Evening",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
          ),
        if (isFiltering)
          Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(.2)))),
            width: double.infinity,
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: openFilterDialogForTags,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      "Tags",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: openFilterDialogForHotels,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      "Hotel",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    "Subscribed",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                // Expanded(
                //     child: Container(
                //   padding: EdgeInsets.symmetric(vertical: 3),
                //   child: Text(
                //     "Job Date",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold),
                //   ),
                // )),
                // Expanded(
                //     child: Container(
                //   padding: EdgeInsets.symmetric(vertical: 3),
                //   child: Text(
                //     "Morning TO Evening",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 12,
                //         fontWeight: FontWeight.bold),
                //   ),
                // )),
              ],
            ),
          ),
      ]),
    );
  }
}
