import 'package:flutter/material.dart';
import 'package:shoptrangle/localization/language_constrants.dart';
import 'package:shoptrangle/provider/order_provider.dart';
import 'package:shoptrangle/provider/profile_provider.dart';
import 'package:shoptrangle/utill/color_resources.dart';
import 'package:shoptrangle/utill/dimensions.dart';
import 'package:shoptrangle/view/basewidget/no_internet_screen.dart';
import 'package:shoptrangle/view/screen/address/widget/address_list_screen.dart';
import 'package:provider/provider.dart';

import 'add_new_address_screen.dart';
class SavedBillingAddressListScreen extends StatelessWidget {
  const SavedBillingAddressListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddNewAddressScreen(isBilling: true))),
        child: Icon(Icons.add, color: Theme.of(context).highlightColor),
        backgroundColor: ColorResources.getPrimary(context),
      ),
      appBar: AppBar(title: Text(getTranslated('BILLING_ADDRESS_LIST', context))),
      body: SafeArea(child: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                profile.billingAddressList != null ? profile.billingAddressList.length != 0 ?  SizedBox(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: profile.billingAddressList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {Provider.of<OrderProvider>(context, listen: false).setBillingAddressIndex(index);
                        Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Container(
                            margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorResources.getIconBg(context),
                              border: index == Provider.of<OrderProvider>(context).billingAddressIndex ? Border.all(width: 2, color: Theme.of(context).primaryColor) : null,
                            ),
                            child: AddressListPage(address: profile.billingAddressList[index]),
                          ),
                        ),
                      );
                    },
                  ),
                )  : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                  child: NoInternetOrDataScreen(isNoInternet: false),
                ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ],
            ),
          );
        },
      )),
    );
  }
}