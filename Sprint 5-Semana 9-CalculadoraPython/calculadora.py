class Calculadora:
    def somar(self, a, b):
        return a + b
    
    def subtrair(self, a, b):
        return a - b
    
    def multiplicar(self, a, b):
        return a * b
    
    def dividir(self, a, b):
        if b == 0:
            raise ValueError("Divisão por zero não é permitida.")
        return a / b
    
    def elevado_ao_quadrado(self, a):
        return a ** 2
    
    def raiz_quadrada(self, a):
        if a < 0:
            raise ValueError("Número negativo não possui raiz quadrada real.")
        return a ** 0.5