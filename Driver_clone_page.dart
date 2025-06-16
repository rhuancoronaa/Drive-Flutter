import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UberClonePage extends StatefulWidget { 
  const UberClonePage({super.key});

  @override
  State<UberClonePage> createState() => _UberClonePageState();
}

class _UberClonePageState extends State<DriverClonePage> {
  late final InAppWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver App'),
        backgroundColor: Colors.black,
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: _buildHtmlContent(),
          mimeType: 'text/html',
          encoding: 'utf-8',
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
      ),
    );
  }

  String _buildHtmlContent() {
    return '''
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
  <title>Driver App</title>
  <style>
    ${_getCssContent()}
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1><strong>Driver</strong></h1>
      <h2>Chamar Corrida</h2>
      <p>Solicite uma corrida em minutos com conforto e segurança</p>
    </div>

    <input type="text" id="destino" placeholder="Digite seu destino..." />

    <div class="options">
      <button onclick="selecionarTipo('Táxi', 35)" id="btn-taxi">Táxi<br />R$35</button>
      <button onclick="selecionarTipo('Conforto', 45)" id="btn-conforto">Conforto<br />R$45</button>
      <button onclick="selecionarTipo('Executivo', 60)" id="btn-executivo">Executivo<br />R$60</button>
    </div>

    <button class="btn-primary" onclick="chamarMotorista()" id="btn-chamar">Chamar Motorista</button>

    <button id="btn-cheguei" onclick="finalizarCorrida()">Cheguei ao destino</button>

    <div class="map-container" id="mapa-container">
      <img src="https://im.ge/i/teste-99.JQtfV1" alt="Mapa Driver" class="map-image">
      <div class="pin"></div>
      <div class="route"></div>
      <div class="driver" id="driver"></div>
      <div class="map-overlay" id="mapa-overlay">Digite seu destino e selecione um tipo de corrida</div>
    </div>

    <div class="payment">
      Pagamento<br />
      Total: <span id="valorTotal">R$0,00</span>
    </div>
    <button class="btn-pay" onclick="pagar('Pix')" id="btn-pix">Pagar com Pix</button>
    <button class="btn-pay" onclick="pagar('Cartão')" id="btn-cartao">Pagar com Cartão</button>

    <div class="message" id="msg-pagamento"></div>
  </div>

  <script>
    ${_getJsContent()}
  </script>
</body>
</html>
''';
  }

  String _getCssContent() {
    return '''
    body {
      font-family: 'Segoe UI', sans-serif;
      background: #f5f5f5;
      margin: 0;
      padding: 0;
      touch-action: manipulation;
    }
    .container {
      background: white;
      border-radius: 15px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      padding: 20px;
      width: 100%;
      max-width: 400px;
      margin: 0 auto;
      box-sizing: border-box;
    }
    .header {
      text-align: center;
      margin-bottom: 10px;
    }
    .header h2 {
      margin: 5px 0;
    }
    input[type="text"] {
      width: 100%;
      padding: 12px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 10px;
      font-size: 16px;
      box-sizing: border-box;
    }
    .options {
      display: flex;
      justify-content: space-between;
      margin-bottom: 15px;
      gap: 8px;
    }
    .options button {
      flex: 1;
      padding: 10px;
      border: 1px solid #ccc;
      background: #fff;
      border-radius: 10px;
      font-weight: bold;
      cursor: pointer;
      font-size: 14px;
    }
    .options button.active {
      background: #007bff;
      color: white;
      border-color: #007bff;
    }
    .btn-primary {
      background: #007bff;
      color: white;
      border: none;
      width: 100%;
      padding: 12px;
      margin-bottom: 15px;
      border-radius: 10px;
      font-size: 16px;
      cursor: pointer;
    }
    .map-container {
      position: relative;
      height: 250px;
      margin-bottom: 15px;
      border-radius: 15px;
      overflow: hidden;
    }
    .map-image {
      width: 100%;
      height: 100%;
      object-fit: cover;
      position: absolute;
      top: 0;
      left: 0;
    }
    .map-overlay {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      background: rgba(0, 0, 0, 0.7);
      color: white;
      padding: 10px;
      text-align: center;
      z-index: 2;
      font-size: 14px;
    }
    .pin {
      position: absolute;
      width: 20px;
      height: 20px;
      background-color: #007bff;
      border-radius: 50% 50% 50% 0;
      transform: rotate(-45deg);
      left: 50%;
      top: 50%;
      margin: -20px 0 0 -10px;
      z-index: 1;
    }
    .pin:after {
      content: '';
      width: 10px;
      height: 10px;
      margin: 5px 0 0 5px;
      background-color: white;
      position: absolute;
      border-radius: 50%;
    }
    .route {
      position: absolute;
      width: 80%;
      height: 6px;
      background-color: #007bff;
      left: 10%;
      top: 40%;
      border-radius: 3px;
      z-index: 1;
    }
    .payment {
      font-weight: bold;
      margin-bottom: 5px;
      font-size: 16px;
    }
    .btn-pay {
      background: #007bff;
      color: white;
      border: none;
      width: 100%;
      padding: 12px;
      border-radius: 10px;
      margin-bottom: 10px;
      font-size: 16px;
      cursor: pointer;
      display: none;
    }
    .message {
      background: #d4edda;
      color: #155724;
      padding: 10px;
      border-radius: 10px;
      display: none;
      margin-top: 10px;
      text-align: center;
      font-size: 14px;
    }
    #btn-cheguei {
      background: #28a745;
      color: white;
      border: none;
      width: 100%;
      padding: 12px;
      border-radius: 10px;
      margin-bottom: 15px;
      font-size: 16px;
      cursor: pointer;
      display: none;
    }
    .driver {
      position: absolute;
      width: 20px;
      height: 20px;
      background-color: #28a745;
      border-radius: 50%;
      left: 20%;
      top: 60%;
      z-index: 1;
      display: none;
    }
    .driver:before {
      content: '';
      position: absolute;
      width: 8px;
      height: 8px;
      background-color: white;
      border-radius: 50%;
      top: 6px;
      left: 6px;
    }
    @keyframes moveDriver {
      0% { left: 20%; top: 60%; }
      25% { left: 40%; top: 50%; }
      50% { left: 60%; top: 55%; }
      75% { left: 80%; top: 45%; }
      100% { left: 20%; top: 60%; }
    }
    ''';
  }

  String _getJsContent() {
    return '''
    let tipoCorrida = '';
    let valorCorrida = 0;
    let corridaEmAndamento = false;
    let corridaFinalizada = false;

    function selecionarTipo(tipo, valor) {
      if (corridaEmAndamento) {
        alert('Você já está em uma corrida.');
        return;
      }
      tipoCorrida = tipo;
      valorCorrida = valor;
      document.getElementById('valorTotal').innerText = 'R$' + valor.toFixed(2).replace('.', ',');

      document.querySelectorAll('.options button').forEach((btn) => btn.classList.remove('active'));
      if (tipo === 'Táxi') document.getElementById('btn-taxi').classList.add('active');
      if (tipo === 'Conforto') document.getElementById('btn-conforto').classList.add('active');
      if (tipo === 'Executivo') document.getElementById('btn-executivo').classList.add('active');
    }

    function chamarMotorista() {
      if (!tipoCorrida) {
        alert('Selecione um tipo de corrida.');
        return;
      }
      const destino = document.getElementById('destino').value;
      if (!destino) {
        alert('Digite o destino.');
        return;
      }
      corridaEmAndamento = true;
      corridaFinalizada = false;

      document.getElementById('mapa-overlay').innerText = 'Rota traçada até ' + destino + ' (' + tipoCorrida + ')... Motorista a caminho';
      
      const driver = document.getElementById('driver');
      driver.style.display = 'block';
      driver.style.animation = 'moveDriver 8s linear infinite';
      
      document.getElementById('btn-cheguei').style.display = 'block';
      document.getElementById('btn-chamar').style.display = 'none';
      document.querySelectorAll('.options button').forEach(btn => btn.disabled = true);
      document.getElementById('destino').disabled = true;
      esconderPagamentos();
      document.getElementById('msg-pagamento').style.display = 'none';
      document.getElementById('msg-pagamento').innerText = '';
    }

    function finalizarCorrida() {
      if (!corridaEmAndamento) {
        alert('Nenhuma corrida em andamento.');
        return;
      }
      corridaFinalizada = true;
      corridaEmAndamento = false;

      const destino = document.getElementById('destino').value;
      document.getElementById('mapa-overlay').innerText = 'Você chegou em ' + destino + '!';
      
      const driver = document.getElementById('driver');
      driver.style.animation = 'none';
      driver.style.display = 'none';
      
      document.getElementById('btn-cheguei').style.display = 'none';
      mostrarPagamentos();
    }

    function pagar(metodo) {
      if (!corridaFinalizada) {
        alert('Finalize a corrida antes de pagar.');
        return;
      }
      const msg = document.getElementById('msg-pagamento');
      msg.innerText = 'Pagamento com ' + metodo + ' enviado com sucesso!\\nObrigado por viajar conosco!';
      msg.style.whiteSpace = 'pre-line';
      msg.style.display = 'block';

      esconderPagamentos();
      setTimeout(resetarApp, 3000);
    }

    function mostrarPagamentos() {
      document.getElementById('btn-pix').style.display = 'block';
      document.getElementById('btn-cartao').style.display = 'block';
    }

    function esconderPagamentos() {
      document.getElementById('btn-pix').style.display = 'none';
      document.getElementById('btn-cartao').style.display = 'none';
    }

    function resetarApp() {
      tipoCorrida = '';
      valorCorrida = 0;
      corridaEmAndamento = false;
      corridaFinalizada = false;

      document.getElementById('valorTotal').innerText = 'R$0,00';
      document.getElementById('mapa-overlay').innerText = 'Digite seu destino e selecione um tipo de corrida';

      document.getElementById('btn-chamar').style.display = 'block';
      document.getElementById('btn-cheguei').style.display = 'none';
      esconderPagamentos();
      document.querySelectorAll('.options button').forEach(btn => {
        btn.disabled = false;
        btn.classList.remove('active');
      });
      document.getElementById('destino').disabled = false;
      document.getElementById('destino').value = '';

      const msg = document.getElementById('msg-pagamento');
      msg.style.display = 'none';
      msg.innerText = '';
    }
    ''';
  }
}
