import 'package:flutter/material.dart';
import 'package:pdf_creator/views/create/create.screen.dart';
import 'package:pdf_creator/views/create/image/image.list.screen.dart';
import 'package:pdf_creator/views/create/text/rte.screen.dart';
import 'package:pdf_creator/views/create/text/single.text.screen.dart';
import 'package:pdf_creator/views/create/text/text.list.screen.dart';
import 'package:pdf_creator/views/saved/saved.lists.dart';

final routes = <String, WidgetBuilder>{
  SavedListScreen.routeName: (context) => const SavedListScreen(),
  CreateScreen.routeName: (context) => const CreateScreen(),
  TextListScreen.routeName: (context) => const TextListScreen(),
  SingleTextScreen.routeName: (context) => const SingleTextScreen(),
  ImageListScreen.routeName: (context) => const ImageListScreen(),
  RteScreen.routeName: (context) => const RteScreen(),
};
