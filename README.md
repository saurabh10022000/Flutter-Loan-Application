# Flutter Loan Application
<img width="1454" alt="Screenshot 2025-01-27 at 12 33 56 PM" src="https://github.com/user-attachments/assets/7d8231b2-f44b-4238-9950-3a09ff1f4ad4" />

A single-page web application built using the Flutter framework and Dart. This application calculates and displays loan-related results based on user inputs and configurations fetched from a remote API.

## Features

- **Annual Business Revenue**: Accepts user input for annual revenue.
- **Loan Amount**: Slider-based input that dynamically adjusts based on the annual revenue.
- **Revenue Share Percentage**: Dynamically calculated based on user inputs.
- **Revenue Shared Frequency**: Radio buttons to select weekly or monthly frequency.
- **Desired Repayment Delay**: Dropdown for repayment delay options.
- **Use of Funds**: Allows users to add multiple rows specifying the type, description, and amount for fund usage.
- **Results Section**: Displays calculated values such as funding amount, fees, total revenue share, expected transfers, and expected completion date.

## Configuration

The application fetches configurations from the following API:
[Configuration JSON](https://gist.githubusercontent.com/motgi/8fc373cbfccee534c820875ba20ae7b5/raw/7143758ff2caa773e651dc3576de57cc829339c0/config.json)

The configuration JSON contains the following keys:
- `name`: Identifier for the configuration.
- `value`: Specific value, range, or options for the UI components.
- `label`: Display label for the UI component.
- `placeholder`: Placeholder text for the input fields.

## Formulas

1. **Revenue Share Percentage**:
   \[
   \text{Repayment Rate} = \left(\frac{0.156}{6.2055 \cdot \text{Revenue Amount}}\right) \cdot (\text{Loan Amount} \cdot 10)
   \]

2. **Expected Transfers**:
   - **Weekly**: 
     \[
     \text{Expected Transfers} = \lceil \frac{\text{Total Revenue Share} \cdot 52}{\text{Business Revenue} \cdot \text{Revenue Share Percentage}} \rceil
     \]
   - **Monthly**: 
     \[
     \text{Expected Transfers} = \lceil \frac{\text{Total Revenue Share} \cdot 12}{\text{Business Revenue} \cdot \text{Revenue Share Percentage}} \rceil
     \]

3. **Expected Completion Date**:
   \[
   \text{Completion Date} = \text{Current Date} + \text{Expected Transfers (weeks/months)} + \text{Repayment Delay}
   \]

Installation Instructions
Clone the Repository

bash
Copy
Edit
git clone https://github.com/saurabh10022000/Flutter-Loan-Application.git
cd Flutter-Loan-Application
Install Dependencies Run the following command to install all required dependencies:

bash
Copy
Edit
flutter pub get
Run the Application Start the Flutter application using:

bash
Copy
Edit
flutter run
Build for the Web If you'd like to build the application for web deployment, run:

bash
Copy
Edit
flutter build web
The build files will be available in the /build/web directory.

Configuration File
The application fetches its configurations from the following API:

Configuration JSON

Example Configuration:
json
Copy
Edit
[
  {
    "name": "revenue_percentage",
    "value": 7.56,
    "placeholder": "Enter annual revenue",
    "funding_amount_min": 1000,
    "funding_amount_max": 500000,
    "revenue_percentage_min": 1.0,
    "revenue_percentage_max": 10.0
  }
]
Keys and Their Uses:
revenue_percentage: Percentage of revenue shared.
placeholder: Placeholder text for the input field.
funding_amount_min / funding_amount_max: Slider limits for loan amounts.
revenue_percentage_min / revenue_percentage_max: Limits for the calculated Revenue Share Percentage.
Formulas Used
Revenue Share Percentage:

Repayment Rate
=
(
0.156
6.2055
⋅
Revenue Amount
)
⋅
(
Loan Amount
⋅
10
)
Repayment Rate=( 
6.2055⋅Revenue Amount
0.156
​
 )⋅(Loan Amount⋅10)
Expected Transfers:

Weekly:
Expected Transfers
=
⌈
Total Revenue Share
⋅
52
Business Revenue
⋅
Revenue Share Percentage
⌉
Expected Transfers=⌈ 
Business Revenue⋅Revenue Share Percentage
Total Revenue Share⋅52
​
 ⌉
Monthly:
Expected Transfers
=
⌈
Total Revenue Share
⋅
12
Business Revenue
⋅
Revenue Share Percentage
⌉
Expected Transfers=⌈ 
Business Revenue⋅Revenue Share Percentage
Total Revenue Share⋅12
​
 ⌉
Expected Completion Date:

Completion Date
=
Current Date
+
Expected Transfers (weeks/months)
+
Repayment Delay
Completion Date=Current Date+Expected Transfers (weeks/months)+Repayment Delay
Screenshots
Input Section:

Results Section:

How to Contribute
Fork the repository.
Create a new branch:
bash
Copy
Edit
git checkout -b feature-name
Commit your changes:
bash
Copy
Edit
git commit -m "Add new feature"
Push to the branch:
bash
Copy
Edit
git push origin feature-name
Create a pull request.
License
This project is open-source and available under the MIT License.

Author
Saurabh Jain
GitHub: saurabh10022000
yaml
Copy
Edit

---

### Instructions to Add to GitHub

1. **Create a `README.md` File**:
   ```bash
   touch README.md
Paste the above content into the README.md file.

Commit and Push:

bash
Copy
Edit
git add README.md
git commit -m "Add README with project details and instructions."
git push origin main
