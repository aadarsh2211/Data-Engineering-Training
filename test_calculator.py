import unittest
from calculator import calculate

class TestCalculate(unittest.TestCase):
    def test_add(self):
        self.assertEqual(calculate(5, 3, '1'), 8)
    
    def test_subtract(self):
        self.assertEqual(calculate(10, 4, '2'), 6)
    
    def test_multiply(self):
        self.assertEqual(calculate(6, 7, '3'), 42)
    
    def test_divide(self):
        self.assertEqual(calculate(20, 4, '4'), 5.0)
    
    def test_divide_zero(self):
        with self.assertRaises(ZeroDivisionError):
            calculate(10, 0, '4')
    
    def test_invalid_operation(self):
        with self.assertRaises(ValueError):
            calculate(5, 3, '5')
    
    def test_string_input(self):
        with self.assertRaises(TypeError):
            calculate("5", 3, '1')

if __name__ == '__main__':
    unittest.main()