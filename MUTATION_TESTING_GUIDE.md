# Mutation Testing - Guia de Referência

## O que é Mutation Testing?
Teste de mutação avalia a **qualidade dos testes** introduzindo pequenas mudanças (mutações) no código fonte e verificando se os testes detectam essas mudanças.

## Conceitos Básicos

### Mutante
Versão modificada do código original com uma pequena alteração.

### Status do Mutante
- **Killed (Morto)** ✓ - Testes falharam (bom! detectou o bug)
- **Survived (Sobreviveu)** ✗ - Testes passaram (ruim! não detectou o bug)
- **Timeout** ⏱ - Teste excedeu tempo limite
- **Not Covered** - Código não coberto por testes

### Mutation Score
```
Mutation Score = (Mutantes Mortos / Total de Mutantes) × 100%
```

## Operadores de Mutação (Dart)

### 1. Arithmetic Operator Replacement (AOR)
Substitui operadores aritméticos:
```dart
// Original
int sum = a + b;
int diff = a - b;
int mult = a * b;
int div = a / b;
int mod = a % b;

// Mutantes
int sum = a - b;  // + → -
int diff = a + b; // - → +
int mult = a / b; // * → /
int div = a * b;  // / → *
int mod = a / b;  // % → /
```

### 2. Relational Operator Replacement (ROR)
Substitui operadores relacionais:
```dart
// Original
if (x > y) { }
if (x >= y) { }
if (x < y) { }
if (x <= y) { }
if (x == y) { }
if (x != y) { }

// Mutantes
if (x >= y) { }  // > → >=
if (x > y) { }   // >= → >
if (x <= y) { }  // < → <=
if (x < y) { }   // <= → <
if (x != y) { }  // == → !=
if (x == y) { }  // != → ==
```

### 3. Logical Operator Replacement (LOR)
Substitui operadores lógicos:
```dart
// Original
if (a && b) { }
if (a || b) { }

// Mutantes
if (a || b) { }  // && → ||
if (a && b) { }  // || → &&
```

### 4. Conditional Expression Replacement (CER)
Nega expressões condicionais:
```dart
// Original
if (condition) { }
while (condition) { }

// Mutantes
if (!condition) { }   // condition → !condition
while (!condition) { } // condition → !condition
```

### 5. Negate Conditional (NC)
Inverte condicionais:
```dart
// Original
if (x > 0) { }

// Mutante
if (!(x > 0)) { }  // Nega toda a condição
```

### 6. Remove Return Statement (RRS)
Remove ou modifica returns:
```dart
// Original
int getValue() {
  return 42;
}

// Mutantes
int getValue() {
  return 0;     // return value → 0
  return null;  // return value → null
  // return;    // Remove return
}
```

### 7. Literal Value Replacement (LVR)
Substitui valores literais:
```dart
// Original
int x = 10;
String s = "hello";
bool flag = true;

// Mutantes
int x = 0;           // 10 → 0
int x = 1;           // 10 → 1
String s = "";       // "hello" → ""
bool flag = false;   // true → false
```

### 8. Null Aware Operator Replacement (NAOR)
Modifica operadores null-aware do Dart:
```dart
// Original
String? name = user?.name;
String greeting = name ?? "Guest";
list?.add(item);

// Mutantes
String? name = user.name;     // ?. → .
String greeting = name;       // ?? → remove
list.add(item);              // ?. → .
```

### 9. Assignment Operator Replacement (ASOR)
Substitui operadores de atribuição:
```dart
// Original
x += 5;
x -= 5;
x *= 5;
x /= 5;

// Mutantes
x = 5;   // += → =
x = 5;   // -= → =
x = 5;   // *= → =
x = 5;   // /= → =
```

### 10. Unary Operator Replacement (UOR)
Modifica operadores unários:
```dart
// Original
x++;
x--;
-x;
!flag;

// Mutantes
x--;     // ++ → --
x++;     // -- → ++
x;       // -x → x
flag;    // !flag → flag
```

## Configuração mutation_test (Dart)

### Arquivo XML Básico
```xml
<?xml version="1.0" encoding="UTF-8"?>
<mutations version="1.1">
  <files>
    <file>lib/path/to/file.dart</file>
  </files>
  
  <commands>
    <command expected-return="0" timeout="60">
      flutter test test/path/to/test_file.dart
    </command>
  </commands>
  
  <rules>
    <!-- Operadores relacionais -->
    <literal text="==" id="op.eq">
      <mutation text="!="/>
    </literal>
    <literal text="!=" id="op.neq">
      <mutation text="=="/>
    </literal>
    <literal text="&gt;" id="op.gt">
      <mutation text="&gt;="/>
      <mutation text="&lt;"/>
    </literal>
    <literal text="&lt;" id="op.lt">
      <mutation text="&lt;="/>
      <mutation text="&gt;"/>
    </literal>
    
    <!-- Operadores lógicos -->
    <literal text="&amp;&amp;" id="op.and">
      <mutation text="||"/>
    </literal>
    <literal text="||" id="op.or">
      <mutation text="&amp;&amp;"/>
    </literal>
    
    <!-- Valores literais -->
    <literal text="null" id="null">
      <mutation text="0"/>
    </literal>
    <literal text="true" id="bool.true">
      <mutation text="false"/>
    </literal>
    <literal text="false" id="bool.false">
      <mutation text="true"/>
    </literal>
    
    <!-- Operadores aritméticos (regex) -->
    <regex pattern="\+([^=+])" id="arith.add">
      <mutation text="-$1"/>
    </regex>
    <regex pattern="-([^=-])" id="arith.sub">
      <mutation text="+$1"/>
    </regex>
    <regex pattern="\*([^=])" id="arith.mul">
      <mutation text="/$1"/>
    </regex>
    <regex pattern="/([^=])" id="arith.div">
      <mutation text="*$1"/>
    </regex>
  </rules>
  
  <exclude>
    <token begin="//" end="\n"/>
    <token begin="import '" end="';"/>
    <token begin="export '" end="';"/>
    <regex pattern="/[*].*?[*]/" dotAll="true"/>
  </exclude>
</mutations>
```

### Arquivo YAML (alternativo)
```yaml
mutate:
  - lib/path/to/file.dart

test_command: flutter test test/path/to/test_file.dart

mutations:
  - arithmetic_operator_replacement
  - logical_operator_replacement
  - relational_operator_replacement
  - conditional_expression_replacement
  - negate_conditional

timeout: 60
```

## Comandos

### Executar mutation test
```bash
dart run mutation_test mutation_test.xml
```

### Ver exemplo de configuração
```bash
dart run mutation_test --show-example
```

### Dry run (contar mutações sem executar)
```bash
dart run mutation_test mutation_test.xml --dry
```

### Gerar relatório em formato específico
```bash
dart run mutation_test mutation_test.xml --format=html
dart run mutation_test mutation_test.xml --format=md
dart run mutation_test mutation_test.xml --format=xml
```

## Boas Práticas

### 1. Comece pequeno
Teste um arquivo por vez antes de escalar para o projeto inteiro.

### 2. Use coverage para otimizar
```bash
dart run mutation_test mutation_test.xml --coverage=coverage/lcov.info
```

### 3. Defina thresholds
```xml
<threshold failure="80">
  <rating over="95" name="A"/>
  <rating over="80" name="B"/>
  <rating over="60" name="C"/>
</threshold>
```

### 4. Exclua código gerado
```xml
<exclude>
  <file>lib/generated/file.g.dart</file>
  <file>lib/generated/file.freezed.dart</file>
</exclude>
```

### 5. Ajuste timeouts
Testes lentos precisam de timeouts maiores para evitar falsos positivos.

## Interpretando Resultados

### Mutation Score Alto (>80%)
✓ Testes de alta qualidade  
✓ Boa cobertura de casos extremos  
✓ Assertions robustas

### Mutation Score Baixo (<60%)
✗ Testes fracos ou incompletos  
✗ Faltam assertions  
✗ Casos extremos não testados

### Mutantes que Sobrevivem Comumente
- Código não coberto por testes
- Testes sem assertions adequadas
- Testes que verificam apenas "happy path"
- Código equivalente (mutação não muda comportamento)

## Exemplo Prático

### Código Original
```dart
class Calculator {
  int add(int a, int b) {
    return a + b;
  }
  
  bool isPositive(int n) {
    return n > 0;
  }
}
```

### Teste Fraco (Mutantes Sobrevivem)
```dart
test('should add numbers', () {
  final calc = Calculator();
  calc.add(2, 3); // ✗ Sem assertion!
});
```

### Teste Forte (Mutantes Morrem)
```dart
test('should add numbers', () {
  final calc = Calculator();
  expect(calc.add(2, 3), equals(5));     // ✓ Mata mutante + → -
  expect(calc.add(-1, 1), equals(0));    // ✓ Testa casos extremos
  expect(calc.add(0, 0), equals(0));     // ✓ Testa zeros
});

test('should check if positive', () {
  final calc = Calculator();
  expect(calc.isPositive(1), isTrue);    // ✓ Mata mutante > → >=
  expect(calc.isPositive(0), isFalse);   // ✓ Testa boundary
  expect(calc.isPositive(-1), isFalse);  // ✓ Testa negativos
});
```

## Referências
- Documentação: https://dartmutant.dev/docs/operators/
- Pacote: https://pub.dev/packages/mutation_test
- Repositório: https://github.com/domohuhn/mutation-test
