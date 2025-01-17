import 'package:flutter/material.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/providers/novost_provider.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../utils/util.dart';

class NovostDetailsScreen extends StatefulWidget {
  Novost? novost;
  static const String routeName = "/novost_details";

  NovostDetailsScreen({super.key, this.novost});

  @override
  State<NovostDetailsScreen> createState() => _NovostDetailsScreenState();
}

class _NovostDetailsScreenState extends State<NovostDetailsScreen> {
  bool showComments = false;

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: widget.novost?.naslov ?? "naslov",
        child: Container(
            width: 800,
            height: 700,
            child: Card(
                //    child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(
                    "${widget.novost?.naslov ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'BeckyTahlia',
                        fontSize: 26,
                        color: Colors.pinkAccent),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.novost?.slikaNovost != null &&
                          widget.novost?.slikaNovost!.slika != ""
                      ? Container(
                          height: 200,
                          width: null,
                          child: ImageFromBase64String(
                              widget.novost!.slikaNovost!.slika),
                        )
                      : Container(
                          child: Image.asset(
                            "assets/images/noImage.jpg",
                            height: 200,
                            width: null,
                            fit: BoxFit.cover,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  //Text("Autor: ${widget.novost?.korisnik?.ime ?? ""}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Datum objavljivanja: ${formatDate(widget.novost!.datumKreiranja!)}",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.novost?.sadrzaj}",
                    textAlign: TextAlign.justify,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("20"),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(onPressed: () {}, child: Text("👍")),
                        ],
                      ),
                      Row(
                        children: [
                          Text("0"),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  showComments = !showComments;
                                });
                              },
                              child: Text("💬")),
                        ],
                      ),
                    ],
                  ),
                  showComments == true
                      ? Container(
                          height: 200,
                          width: 800,
                          child: Card(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _showComments(),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _createComment()
                ]),
                //)
              ),
            ))));
  }

  void _giveLike() {
    //poziv u bazu, loggedUser id u novostLikeKomment tabeli
  }
  //promijeni emoji ako korisnik lajka ili komentarise
  //obrisi, edituj komentar (svoj). (Moje recenzije za novosti - svidjanja i komentari)
  //uraditi isto kao za recenzije: usluga details-sve recenzije-delete, stranica edit. profil - lajkovi,komentari - delete, stranica edit

  Widget _createComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Write a comment:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextField(
          // controller: _commentController,
          maxLines: 5, // Allows multi-line input
          decoration: InputDecoration(
            hintText: "Type your comment here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _saveComment,
              child: Text("Save"),
            ),
          ],
        ),
      ],
    );
  }

  void _saveComment() {
    // String comment = _commentController.text.trim();
    // if (comment.isNotEmpty) {
    //   // Handle saving the comment (e.g., send to server or add to list)
    //   print("Saved comment: $comment");
    //   _commentController.clear(); // Clear the text area
    // } else {
    //   // Show error or feedback
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Comment cannot be empty")),
    //   );
    // }
  }

  Widget _showComments() {
    var comments = [
      {'username': 'user1', 'comment': 'komm1'},
      {'username': 'user2', 'comment': 'This is a longer comment.'},
      {'username': 'user3', 'comment': 'Nice post!'},
    ];

    return Column(
      children: comments.map((comment) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment['username'] ?? 'Unknown',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  comment['comment'] ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
