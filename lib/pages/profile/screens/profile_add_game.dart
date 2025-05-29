import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/blocks/block_image.dart';
import 'package:flutter_code_challenge/blocks/block_unfocus_tap.dart';
import 'package:flutter_code_challenge/extensions/image_picker.dart';
import 'package:flutter_code_challenge/extensions/snackbar_extension.dart';
import 'package:flutter_code_challenge/state/loading_state.dart';
import 'package:flutter_code_challenge/state/product_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAddGame extends HookConsumerWidget{

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final add_product_loading = ref.watch(loading_state('add_product_loading'));

    final formKey = useMemoized(() => GlobalKey<FormState>());

    final nameInput = useTextEditingController();
    final descriptionInput = useTextEditingController();
    final priceInput = useTextEditingController();

    final image_picker_listenable = useState<String?>(null);
    final imageSize = MediaQuery.of(context).size.width * 0.5;

    return add_product_loading == LoadingIndicatorState.loading
      ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
      : BlockUnfocusTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Game'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12.0),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      
                      Container(
                        width: imageSize, height: imageSize,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () async{
                            // Open image picker
                            await function_imagePicker( 
                              imageSource: ImageSource.gallery, 
                              imagePickerListenable: image_picker_listenable 
                            );
                          },
                          child: BlockImage(
                            backgroundColor: Colors.transparent,
                            iconSize: imageSize * 0.3,
                            width: imageSize, height: imageSize,
                            imageLocal: image_picker_listenable.value,
                          ),
                        ),
                      ),

                      TextFormField(
                        controller: nameInput,
                        decoration: InputDecoration(labelText: 'Game Name'),
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: descriptionInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        autocorrect: false,
                        minLines: 1,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: priceInput,
                        decoration: InputDecoration(labelText: 'Price'),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Price is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
      
                          if (formKey.currentState?.validate() == true) {
                            ref.read(product_state.notifier).add_product({
                              'name': nameInput.text,
                              'description': descriptionInput.text,
                              'price': int.tryParse(priceInput.text) ?? 0,
                              'image': image_picker_listenable.value,
                            }, prefix_loading: 'add_product_loading', onCallback: () async {

                              if(Navigator.canPop(context)){
                                Navigator.pop(context);
                              }
                              context.showSnackbar(
                                title: 'Game added successfully',
                                showDuration: Duration(milliseconds: 2000),
                              );

                            });
                          }
      
                        },
                        child: Text('Add Game'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,400}'); // 800 is safe for most consoles
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}