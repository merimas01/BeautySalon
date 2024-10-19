import 'package:desktop_app/models/rezervacija_update.dart';
import 'package:desktop_app/providers/rezarvacije_provider.dart';
import 'package:desktop_app/screens/rezervacije_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../models/status.dart';
import '../providers/status_provider.dart';
import '../widgets/master_screen.dart';

class RezervacijeUpdateStatus extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijeUpdateStatus({super.key, required this.rezervacija});

  @override
  State<RezervacijeUpdateStatus> createState() =>
      _RezervacijeUpdateStatusState();
}

class _RezervacijeUpdateStatusState extends State<RezervacijeUpdateStatus> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late StatusiProvider _statusiProvider;
  late RezervacijeProvider _rezervacijeProvider;
  SearchResult<Status>? _statusiResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'rezervacijaId': widget.rezervacija?.rezervacijaId.toString(),
      'korisnikId': widget.rezervacija?.korisnikId.toString(),
      'uslugaId': widget.rezervacija?.uslugaId.toString(),
      'terminId': widget.rezervacija?.terminId.toString(),
      'statusId': widget.rezervacija?.statusId.toString(),
      'datumRezervacije': widget.rezervacija?.datumRezervacije,
    };
    _statusiProvider = context.read<StatusiProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();

    print(_initialValue);
    initForm();
  }

  Future initForm() async {
    _statusiResult = await _statusiProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [isLoading ? Container() : _buildForm(), _saveAction()],
      ),
      title: "Promijeni status",
    );
  }

  Widget _saveAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 600.0),
          child: ElevatedButton(
              onPressed: () async {
                var val = _formKey.currentState?.saveAndValidate();
                var request = new Map.from(_formKey.currentState!.value);
                print("request: ${request}");
                var rezervacija_update = RezervacijaUpdate(
                    int.parse(_initialValue['korisnikId']),
                    int.parse(_initialValue['uslugaId']),
                    int.parse(_initialValue['terminId']),
                    _initialValue['datumRezervacije'],
                    int.parse(request['statusId']));

                if (val == true) {
                  if (widget.rezervacija?.rezervacijaId != null) {
                    var update_status = await _rezervacijeProvider.update(
                        widget.rezervacija!.rezervacijaId!, rezervacija_update);
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Informacija o uspjehu"),
                            content: Text("Uspješno izvršena akcija!"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RezervacijeListScreen()));
                                  },
                                  child: Text("Ok"))
                            ],
                          ));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Čreška"),
                            content: Text("Molimo Vas izaberite status."),
                          ));
                }
              },
              child: Text("Spasi")),
        ),
      ],
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.only(
              right: 300.0, top: 100.0, left: 300.0, bottom: 50.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown<String>(
                    name: 'statusId',
                    decoration: InputDecoration(
                      labelText: 'Statusi',
                      suffix: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['statusId']?.reset();
                        },
                      ),
                      hintText: 'Odaberite novi status',
                    ),
                    items: _statusiResult?.result
                            .map((item) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  value: item.statusId.toString(),
                                  child: Text(item.opis ?? ""),
                                ))
                            .toList() ??
                        [],
                    validator: (value) {
                      if (value == null) {
                        return 'Molimo Vas izaberite novi status';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
