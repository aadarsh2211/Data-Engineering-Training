def calculate(num1, num2, choice):
    if choice == '1':
        return num1 + num2
    elif choice == '2':
        return num1 - num2
    elif choice == '3':
        return num1 * num2
    elif choice == '4':
        return num1 / num2
    else:
        raise ValueError("Invalid operation")


def run_calculator():
    try:
        num1 = float(input("first number: "))
        num2 = float(input("second number: "))
    except ValueError:
        print("Please enter valid numbers.")
        return

    print("Choose operation:\n1 - Add\n2 - Subtract\n3 - Multiply\n4 - Divide")
    choice = input("Enter choice (1/2/3/4): ")

    try:
        result = calculate(num1, num2, choice)
        print("Result:", result)
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    run_calculator()