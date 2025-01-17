import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:solana_mobile_wallet/solana_mobile_wallet.dart';

import '../../../config.dart';
import 'models/notification.dart';
import 'models/remote_request.dart';
import 'repository.dart';

@injectable
class ScenarioHandler implements ScenarioCallbacks {
  ScenarioHandler(this._repository) {
    _init();
  }

  final MobileWalletRepository _repository;
  late final Scenario? _scenario;

  Future<void> _init() async {
    _scenario = await Scenario.create(
      walletConfig: const MobileWalletAdapterConfig(
        supportsSignAndSendTransactions: true,
        maxTransactionsPerSigningRequest: maxPayloadsPerSigningRequest,
        maxMessagesPerSigningRequest: maxPayloadsPerSigningRequest,
        supportedTransactionVersions: ['legacy'],
      ),
      issuerConfig: const AuthIssuerConfig(name: 'Espresso Cash'),
      callbacks: this,
    );

    _scenario?.start();
    log('Scenario initialized');
  }

  @override
  Future<AuthorizeResult?> onAuthorizeRequest(AuthorizeRequest request) async {
    final remoteRequest = RemoteRequest.authorizeDapp(request: request);

    return _repository.notifyApp(
      MobileWalletNotification.request(remoteRequest),
    );
  }

  @override
  Future<bool> onReauthorizeRequest(
    ReauthorizeRequest request,
  ) async =>
      true;

  @override
  Future<SignaturesResult?> onSignAndSendTransactionsRequest(
    SignAndSendTransactionsRequest request,
  ) async {
    final remoteRequest =
        RemoteRequest.signTransactionsForSending(request: request);

    return _repository.notifyApp(
      MobileWalletNotification.request(remoteRequest),
    );
  }

  @override
  Future<SignedPayloadResult?> onSignMessagesRequest(
    SignMessagesRequest request,
  ) async {
    final remoteRequest = RemoteRequest.signPayloads(request: request);

    return _repository.notifyApp(
      MobileWalletNotification.request(remoteRequest),
    );
  }

  @override
  Future<SignedPayloadResult?> onSignTransactionsRequest(
    SignTransactionsRequest request,
  ) async {
    final remoteRequest = RemoteRequest.signPayloads(request: request);

    return _repository.notifyApp(
      MobileWalletNotification.request(remoteRequest),
    );
  }

  @override
  void onScenarioServingComplete() {
    _scenario?.close();
  }

  @override
  void onScenarioComplete() {}

  @override
  void onScenarioError() {}

  @override
  void onScenarioReady() {
    _repository.notifyApp<void>(
      const MobileWalletNotification.initialized(),
    );
  }

  @override
  void onScenarioServingClients() {}

  @override
  void onScenarioTeardownComplete() {
    _repository.notifyApp<void>(
      const MobileWalletNotification.sessionTerminated(),
    );
  }

  @override
  Future<void> onDeauthorizeEvent(DeauthorizeEvent event) async {
    _repository.notifyApp<void>(
      const MobileWalletNotification.deauthorized(),
    );
  }

  @override
  void onLowPowerAndNoConnection() {}
}
