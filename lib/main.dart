import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  runApp(const ReportApp());
}

class ReportApp extends StatelessWidget {
  const ReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0E4B67);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relatorios Fotograficos',
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, child) => ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: false,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          primary: seed,
          secondary: const Color(0xFFD99B4E),
          surface: const Color(0xFFF8FBFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6F8),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          },
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF123447),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF123447),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: seed),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD7E6EE), Color(0xFFF3F6F8)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF123447), Color(0xFF0E4B67)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x220E4B67),
                      blurRadius: 24,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Fluxo tecnico e profissional',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Gerador de\nRelatorios Fotograficos',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Crie relatorios tecnicos de manutencao, capture assinatura digital e gere um PDF profissional.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        HomeMetric(label: 'PDF imediato'),
                        HomeMetric(label: 'Assinatura digital'),
                        HomeMetric(label: 'Dados salvos'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Acesso rapido',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF123447),
                ),
              ),
              const SizedBox(height: 14),
              HomeCard(
                title: 'Geracao de relatorio tecnico de manutencao',
                subtitle:
                    'Formulario completo com observacao, assinatura e PDF.',
                icon: Icons.description_outlined,
                color: const Color(0xFF0E4B67),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ReportFormPage(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              HomeCard(
                title: 'Visualizar dados',
                subtitle: 'Consulte os relatorios salvos no dispositivo.',
                icon: Icons.storage_rounded,
                color: const Color(0xFFD99B4E),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ReportsPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportFormPage extends StatefulWidget {
  const ReportFormPage({super.key});

  @override
  State<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends State<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final _client = TextEditingController();
  final _bairro = TextEditingController();
  final _rua = TextEditingController();
  final _numero = TextEditingController();
  final _equipamento = TextEditingController();
  final _numeroCliente = TextEditingController();
  final _observacao = TextEditingController();
  final Map<String, bool> _tipos = {
    'Troca': false,
    'Assistencia': false,
    'Atendimento': false,
    'Outros': false,
  };

  DateTime _dataManutencao = DateTime.now();
  Uint8List? _assinatura;
  bool _saving = false;

  int get _camposPreenchidos {
    var total = 0;
    for (final controller in [
      _client,
      _bairro,
      _rua,
      _numero,
      _equipamento,
      _numeroCliente,
      _observacao,
    ]) {
      if (controller.text.trim().isNotEmpty) total++;
    }
    if (_tipos.values.any((value) => value)) total++;
    if (_assinatura != null) total++;
    return total;
  }

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _client,
      _bairro,
      _rua,
      _numero,
      _equipamento,
      _numeroCliente,
      _observacao,
    ]) {
      controller.addListener(_refreshProgress);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _client,
      _bairro,
      _rua,
      _numero,
      _equipamento,
      _numeroCliente,
      _observacao,
    ]) {
      controller.removeListener(_refreshProgress);
    }
    _client.dispose();
    _bairro.dispose();
    _rua.dispose();
    _numero.dispose();
    _equipamento.dispose();
    _numeroCliente.dispose();
    _observacao.dispose();
    super.dispose();
  }

  void _refreshProgress() {
    if (mounted) setState(() {});
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: _dataManutencao,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dataManutencao = picked);
    }
  }

  Future<void> _abrirAssinatura() async {
    final assinatura = await Navigator.of(context).push<Uint8List?>(
      MaterialPageRoute<Uint8List?>(builder: (_) => const SignaturePage()),
    );
    if (assinatura != null) {
      setState(() => _assinatura = assinatura);
    }
  }

  Future<void> _salvarGerarPdf() async {
    if (!_formKey.currentState!.validate()) return;
    final tipos = _tipos.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    if (tipos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione ao menos um tipo de atendimento.'),
        ),
      );
      return;
    }
    if (_assinatura == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione a assinatura do cliente.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final report = ReportRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        client: _client.text.trim(),
        bairro: _bairro.text.trim(),
        rua: _rua.text.trim(),
        numero: _numero.text.trim(),
        equipamento: _equipamento.text.trim(),
        dataManutencao: _dataManutencao,
        numeroCliente: _numeroCliente.text.trim(),
        tipos: tipos,
        observacao: _observacao.text.trim(),
        assinaturaBase64: base64Encode(_assinatura!),
        criadoEm: DateTime.now(),
      );

      await ReportStore.save(report);
      final pdfBytes = await PdfService.build(report, _assinatura!);
      final file = await PdfService.save(report, pdfBytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relatorio salvo em ${file.path}')),
      );
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PdfPage(pdfBytes: pdfBytes, path: file.path),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _camposPreenchidos / 9;
    return Scaffold(
      appBar: AppBar(title: const Text('Relatorio tecnico de manutencao')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF123447),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preencha os dados do atendimento',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fluxo pensado para coleta rapida em campo, com assinatura e geracao imediata do PDF.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        color: const Color(0xFFD99B4E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).round()}% do relatorio preenchido',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Dados do cliente',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _client,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      validator: requiredField,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _bairro,
                            decoration: const InputDecoration(
                              labelText: 'Bairro',
                            ),
                            validator: requiredField,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _rua,
                            decoration: const InputDecoration(labelText: 'Rua'),
                            validator: requiredField,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _numero,
                            decoration: const InputDecoration(
                              labelText: 'Numero',
                            ),
                            validator: requiredField,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _numeroCliente,
                            decoration: const InputDecoration(
                              labelText: 'Numero do cliente',
                            ),
                            validator: requiredField,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Atendimento tecnico',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _equipamento,
                      decoration: const InputDecoration(
                        labelText: 'Equipamento',
                      ),
                      validator: requiredField,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selecionarData,
                      borderRadius: BorderRadius.circular(16),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data de manutencao',
                          suffixIcon: Icon(Icons.calendar_month_outlined),
                        ),
                        child: Text(_dateFormat.format(_dataManutencao)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tipo de atendimento',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _tipos.keys.map((tipo) {
                        final selected = _tipos[tipo] ?? false;
                        return FilterChip(
                          selected: selected,
                          label: Text(tipo),
                          avatar: Icon(
                            selected ? Icons.check_circle : Icons.build_circle,
                            size: 18,
                            color: selected
                                ? const Color(0xFF0E4B67)
                                : const Color(0xFF6A7B85),
                          ),
                          selectedColor: const Color(0xFFDCEAF0),
                          side: BorderSide(
                            color: selected
                                ? const Color(0xFF0E4B67)
                                : const Color(0xFFD7E0E8),
                          ),
                          onSelected: (value) =>
                              setState(() => _tipos[tipo] = value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _observacao,
                      minLines: 5,
                      maxLines: 7,
                      validator: requiredField,
                      decoration: const InputDecoration(
                        labelText: 'Observacao',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Assinatura do cliente',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RepaintBoundary(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 190,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FBFD),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _assinatura == null
                                ? const Color(0xFFD7E0E8)
                                : const Color(0xFF0E4B67),
                            width: _assinatura == null ? 1 : 1.4,
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _assinatura == null
                              ? const Center(
                                  key: ValueKey('empty-signature'),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.border_color_rounded,
                                        size: 32,
                                        color: Color(0xFF6A7B85),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Nenhuma assinatura capturada'),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  key: const ValueKey('filled-signature'),
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.memory(
                                    _assinatura!,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.medium,
                                    gaplessPlayback: true,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: _abrirAssinatura,
                      icon: Icon(
                        _assinatura == null
                            ? Icons.draw_outlined
                            : Icons.edit_outlined,
                      ),
                      label: Text(
                        _assinatura == null
                            ? 'Abrir tela de assinatura'
                            : 'Refazer assinatura',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: FilledButton.icon(
                  key: ValueKey(_saving),
                  onPressed: _saving ? null : _salvarGerarPdf,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0E4B67),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(
                    _saving ? 'Gerando PDF...' : 'Salvar dados e gerar PDF',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late Future<List<ReportRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = ReportStore.load();
  }

  Future<void> _reload() async {
    setState(() => _future = ReportStore.load());
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizar dados')),
      body: FutureBuilder<List<ReportRecord>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                children: const [
                  SizedBox(height: 220),
                  Center(child: Text('Nenhum relatorio salvo ainda.')),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE0E7EC)),
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCEAF0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF0E4B67),
                        ),
                      ),
                      title: Text(
                        item.client,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${item.equipamento} - ${fmt.format(item.dataManutencao)}',
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.tipos
                              .map(
                                (tipo) => Chip(
                                  label: Text(tipo),
                                  side: BorderSide.none,
                                  backgroundColor: const Color(0xFFF0F5F8),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 14),
                        InfoRow(label: 'Endereco', value: item.endereco),
                        InfoRow(
                          label: 'Numero do cliente',
                          value: item.numeroCliente,
                        ),
                        InfoRow(label: 'Observacao', value: item.observacao),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SignaturePage extends StatefulWidget {
  const SignaturePage({super.key});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: const Color(0xFF123447),
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faca a assinatura antes de confirmar.')),
      );
      return;
    }
    final bytes = await _controller.toPngBytes();
    if (!mounted || bytes == null) return;
    Navigator.of(context).pop(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assinatura')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD7E0E8)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Signature(
                      controller: _controller,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _controller.clear,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Limpar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _confirmar,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfPage extends StatelessWidget {
  const PdfPage({super.key, required this.pdfBytes, required this.path});

  final Uint8List pdfBytes;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF gerado')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF123447),
            padding: const EdgeInsets.all(16),
            child: Text(path, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            child: PdfPreview(
              canChangeOrientation: false,
              canChangePageFormat: false,
              build: (_) async => pdfBytes,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportRecord {
  ReportRecord({
    required this.id,
    required this.client,
    required this.bairro,
    required this.rua,
    required this.numero,
    required this.equipamento,
    required this.dataManutencao,
    required this.numeroCliente,
    required this.tipos,
    required this.observacao,
    required this.assinaturaBase64,
    required this.criadoEm,
  });

  final String id;
  final String client;
  final String bairro;
  final String rua;
  final String numero;
  final String equipamento;
  final DateTime dataManutencao;
  final String numeroCliente;
  final List<String> tipos;
  final String observacao;
  final String assinaturaBase64;
  final DateTime criadoEm;

  String get endereco => '$rua, $numero - $bairro';

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client,
    'bairro': bairro,
    'rua': rua,
    'numero': numero,
    'equipamento': equipamento,
    'dataManutencao': dataManutencao.toIso8601String(),
    'numeroCliente': numeroCliente,
    'tipos': tipos,
    'observacao': observacao,
    'assinaturaBase64': assinaturaBase64,
    'criadoEm': criadoEm.toIso8601String(),
  };

  factory ReportRecord.fromJson(Map<String, dynamic> json) => ReportRecord(
    id: json['id'] as String,
    client: json['client'] as String,
    bairro: json['bairro'] as String,
    rua: json['rua'] as String,
    numero: json['numero'] as String,
    equipamento: json['equipamento'] as String,
    dataManutencao: DateTime.parse(json['dataManutencao'] as String),
    numeroCliente: json['numeroCliente'] as String,
    tipos: List<String>.from(json['tipos'] as List<dynamic>),
    observacao: json['observacao'] as String,
    assinaturaBase64: json['assinaturaBase64'] as String,
    criadoEm: DateTime.parse(json['criadoEm'] as String),
  );
}

class ReportStore {
  static const key = 'saved_reports';

  static Future<void> save(ReportRecord report) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await load();
    items.insert(0, report);
    await prefs.setStringList(
      key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<List<ReportRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? <String>[];
    return list
        .map(
          (e) => ReportRecord.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
  }
}

class PdfService {
  static final _fmt = DateFormat('dd/MM/yyyy');
  static const _footerText =
      'Praca Chui, 100 - Bairro Joao Pinheiro, Belo Horizonte - MG, CEP: 30.530.120';

  static Future<Uint8List> build(
    ReportRecord report,
    Uint8List assinatura,
  ) async {
    final doc = pw.Document();
    final signatureImage = pw.MemoryImage(assinatura);
    final logoData = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 42),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 10),
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Divider(color: PdfColor.fromHex('#D7E0E8'), height: 1),
              pw.SizedBox(height: 8),
              pw.Text(
                _footerText,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColor.fromHex('#5C6C75'),
                ),
              ),
            ],
          ),
        ),
        build: (_) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#0E4B67'),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: 84,
                  height: 84,
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(14),
                  ),
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),
                pw.SizedBox(width: 18),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'RELATORIO TECNICO DE MANUTENCAO',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Documento emitido pelo aplicativo mobile.',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 18),
          _pdfBox('Dados do cliente', [
            _pdfInfo('Cliente', report.client),
            _pdfInfo('Endereco', report.endereco),
            _pdfInfo('Numero do cliente', report.numeroCliente),
          ]),
          pw.SizedBox(height: 12),
          _pdfBox('Informacoes do atendimento', [
            _pdfInfo('Equipamento', report.equipamento),
            _pdfInfo('Data de manutencao', _fmt.format(report.dataManutencao)),
            _pdfInfo('Tipo de atendimento', report.tipos.join(', ')),
          ]),
          pw.SizedBox(height: 12),
          _pdfBox('Observacao', [
            pw.Text(
              report.observacao,
              style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
            ),
          ]),
          pw.SizedBox(height: 12),
          _pdfBox('Assinatura do cliente', [
            pw.Container(
              height: 120,
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromHex('#BCCAD3')),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Image(signatureImage, fit: pw.BoxFit.contain),
            ),
          ]),
          pw.SizedBox(height: 18),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Emitido em ${_fmt.format(report.criadoEm)}'),
          ),
        ],
      ),
    );
    return doc.save();
  }

  static Future<File> save(ReportRecord report, Uint8List pdfBytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final safe = report.client.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final file = File('${dir.path}\\relatorio_${safe}_${report.id}.pdf');
    return file.writeAsBytes(pdfBytes, flush: true);
  }

  static pw.Widget _pdfBox(String title, List<pw.Widget> children) =>
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(12),
          border: pw.Border.all(color: PdfColor.fromHex('#D7E0E8')),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#123447'),
              ),
            ),
            pw.SizedBox(height: 10),
            ...children,
          ],
        ),
      );

  static pw.Widget _pdfInfo(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(text: value),
        ],
      ),
    ),
  );
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF123447),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF49606B),
                                height: 1.35,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5F8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMetric extends StatelessWidget {
  const HomeMetric({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF123447),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(height: 1.4),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) return 'Campo obrigatorio';
  return null;
}
