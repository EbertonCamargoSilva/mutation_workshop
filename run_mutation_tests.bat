@echo off
echo ========================================
echo EXECUTANDO TESTES DE MUTACAO
echo ========================================

echo.
echo 1. Executando testes normais primeiro...
flutter test

echo.
echo 2. Gerando mocks atualizados...
flutter pub run build_runner build --delete-conflicting-outputs

echo.
echo 3. Executando testes de mutacao do UseCase...
flutter test test/src/domain/usecases/todo_usecase_mutation_test.dart

echo.
echo 4. Executando testes do Repository...
flutter test test/src/data/repository/todo_repository_impl_test.dart

echo.
echo 5. Executando testes do Model...
flutter test test/src/domain/models/todo_model_test.dart

echo.
echo ========================================
echo TESTES DE MUTACAO CONCLUIDOS
echo ========================================

echo.
echo Para executar mutation testing com ferramenta externa:
echo dart pub add mutation_test
echo dart run mutation_test mutation_test.xml

pause