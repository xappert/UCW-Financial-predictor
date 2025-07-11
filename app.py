from financial_logic import compare_rates
from prompt_generator import generate_prompt

def main():
    try:
        # Get user input
        loan_rate = float(input("Enter loan interest rate (%): "))
        investment_return = float(input("Enter expected investment return (%): "))
        risk_tolerance = input("Enter risk tolerance (low/medium/high): ").lower()
        
        # Validate risk tolerance
        if risk_tolerance not in ["low", "medium", "high"]:
            raise ValueError("Invalid risk tolerance. Must be low/medium/high")
        
        # Get local decision and AI prompt
        result = compare_rates(loan_rate, investment_return, risk_tolerance)
        ai_prompt = generate_prompt(loan_rate, investment_return, risk_tolerance)
        
        # Display results
        print("\n" + "="*50)
        print(f"Local Decision: {result['decision']}")
        print(f"Reason: {result['reason']}\n")
        print("AI Prompt:")
        print(f'"{ai_prompt}"\n')
        print("Note: The AI doesn't just give yes/no but provides contextual reasoning.")
        print("="*50)
        
    except ValueError as e:
        print(f"\nError: {e}")
        print("Please enter valid inputs\n")
        main()  # Restart on error

def run_demo():
    """Run with sample hardcoded values"""
    print("\nRunning demo with sample values...")
    loan_rate = 4.5
    investment_return = 7.0
    risk_tolerance = "high"
    
    result = compare_rates(loan_rate, investment_return, risk_tolerance)
    ai_prompt = generate_prompt(loan_rate, investment_return, risk_tolerance)
    
    print("\n" + "="*50)
    print(f"Local Decision: {result['decision']}")
    print(f"Reason: {result['reason']}\n")
    print("AI Prompt:")
    print(f'"{ai_prompt}"\n')
    print("Note: The AI doesn't just give yes/no but provides contextual reasoning.")
    print("="*50)

if __name__ == "__main__":
    print("Financial Analysis Tool")
    print("1. Use custom inputs")
    print("2. Run demo")
    
    choice = input("\nEnter choice (1 or 2): ")
    if choice == "1":
        main()
    elif choice == "2":
        run_demo()
    else:
        print("Invalid choice. Exiting.")