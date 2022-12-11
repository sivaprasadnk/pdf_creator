import 'package:flutter/material.dart';
import 'package:pdf_creator/views/create/create.screen.dart';
import 'package:pdf_creator/views/saved/saved.lists.dart';

enum SavedView { list, grid }

enum SavedSort { asc, desc }

class HomeMenu {
  String title;
  IconData icon;
  String routeName;
  HomeMenu({
    required this.title,
    required this.icon,
    required this.routeName,
  });
}

List<HomeMenu> homeMenuList = [
  HomeMenu(
    title: 'View Saved',
    icon: Icons.save_outlined,
    routeName: SavedListScreen.routeName,
  ),
  HomeMenu(
    title: 'Create new',
    icon: Icons.edit,
    routeName: CreateScreen.routeName,
  ),
];
