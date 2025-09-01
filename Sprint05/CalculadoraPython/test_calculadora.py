import unittest
from calculadora import Calculadora

class TestCalculadora(unittest.TestCase):

    def setUp(self):
        self.calc = Calculadora()

    def test_somar(self):
        """Testa a soma de dois números."""
        resultado = self.calc.somar(5, 3)
        self.assertEqual(resultado, 8)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_somar_dois(self):
        """Testa a soma de dois números."""
        resultado = self.calc.somar(5, 3)
        self.assertEqual(resultado, 9)

    def test_subtrair(self):
        """Testa a subtração de dois números."""
        resultado = self.calc.subtrair(10, 4)
        self.assertEqual(resultado, 6)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_subtrair_dois(self):
        """Testa a subtração de dois números."""
        resultado = self.calc.subtrair(10, 4)
        self.assertEqual(resultado, 5)
    
    def test_multiplicar(self):
        """Testa a multiplicação de dois números."""
        resultado = self.calc.multiplicar(3, 4)
        self.assertEqual(resultado, 12)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_multiplicar_dois(self):
        """Testa a multiplicação de dois números."""
        resultado = self.calc.multiplicar(3, 4)
        self.assertEqual(resultado, 11)

    def test_dividir(self):
        """Testa a divisão de dois números."""
        resultado = self.calc.dividir(8, 2)
        self.assertEqual(resultado, 4)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_dividir_por_zero(self):
        """Testa a divisão por zero."""
        with self.assertRaises(ZeroDivisionError):
            self.calc.dividir(8, 0)
        
    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_dividir_dois(self):
        """Testa a divisão de dois números."""
        resultado = self.calc.dividir(8, 2)
        self.assertEqual(resultado, 5)

    def test_elevado_ao_quadrado(self):
        """Testa a elevação ao quadrado de um número."""
        resultado = self.calc.elevado_ao_quadrado(3)
        self.assertEqual(resultado, 9)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_elevado_ao_quadrado_dois(self):
        """Testa a elevação ao quadrado de um número."""
        resultado = self.calc.elevado_ao_quadrado(3)
        self.assertEqual(resultado, 8)

    def test_raiz_quadrada(self):
        """Testa a raiz quadrada de um número."""
        resultado = self.calc.raiz_quadrada(16)
        self.assertEqual(resultado, 4)

    #TESTE COM ERRO PARA TESTE DE ENTRADA
    def test_raiz_quadrada_dois(self):
        """Testa a raiz quadrada de um número."""
        resultado = self.calc.raiz_quadrada(16)
        self.assertEqual(resultado, 5)

if __name__ == '__main__':
    unittest.main()