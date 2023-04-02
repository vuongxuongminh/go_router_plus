import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:mockito/annotations.dart';

import 'redirectors.dart';
import 'redirectors_test.mocks.dart';
import 'screens.dart';

@GenerateMocks([GoRouterState, BuildContext])
void main() {
  test(
    'test non restrict screen, chain redirector should not redirect',
    () async {
      final redirector = ChainRedirector([
        RedirectorA(),
      ]);

      expect(
        await redirector.redirect(
          ScreenB(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        null,
      );
    },
  );

  test(
    'test restrict screen, chain redirector should redirect',
    () async {
      final redirector = ChainRedirector([
        RedirectorA(),
      ]);

      expect(
        await redirector.redirect(
          ScreenA(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        '/b',
      );
    },
  );

  test(
    'test chain redirector always redirect',
    () async {
      final redirector = ChainRedirector([
        RedirectorC(),
        RedirectorB(),
      ]);

      expect(
        await redirector.redirect(
          ScreenA(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        '/b',
      );
      expect(
        await redirector.redirect(
          ScreenB(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        '/b',
      );
      expect(
        await redirector.redirect(
          ScreenC(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        '/b',
      );
    },
  );

  test('test screen rediretor should redirect', () {
    final redirector = ScreenRedirector();

    expect(
      redirector.redirect(
        AwareRedirectScreenH(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      '/a',
    );
    expect(redirector.shouldRedirect(AwareRedirectScreenH()), true);
  });

  test('test screen rediretor should not redirect', () {
    final redirector = ScreenRedirector();

    expect(
      () => redirector.redirect(
        ScreenA(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      throwsA(isA<UnexpectedScreenException>()),
    );
    expect(redirector.shouldRedirect(ScreenA()), false);
  });
}
