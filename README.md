# RentACar

![Project Logo](https://github.com/Xersante/rentACar/blob/main/project-logo.jpeg)

## About Me

My name is Furkan Uluçay, and I am a 3rd-year computer engineering student at Izmir Institute of Technology. I have a strong passion for blockchain technologies, which drives my academic and personal projects. My journey into the world of blockchain began with a curiosity about decentralized systems and how they can revolutionize traditional industries. As I continue my studies, I aim to deepen my knowledge and contribute to innovative solutions within the blockchain space.

## Description

RentACar is a blockchain-based car rental platform inspired by the "getiraraç" project, adapted for the Scroll Blockchain. The project allows users to interact directly with a decentralized smart contract to manage car rentals. Key features include adding and removing cars from the system, renting available vehicles, and handling refunds for specific transactions. By leveraging blockchain technology, RentACar ensures transparency, security, and automation in the car rental process, reducing the need for intermediaries. This project showcases the potential of decentralized applications (dApps) in modernizing traditional services by enhancing user trust and operational efficiency.

## Vision

RentACar aims to revolutionize the car rental industry by providing a more reliable and transparent way for people to rent vehicles. By utilizing blockchain technology, RentACar ensures that all transactions are secure, verifiable, and free from third-party interference. This approach enhances user trust, reduces fraud, and streamlines the rental process. The project envisions a future where renting a car is as simple and trustworthy as any other digital service, empowering users worldwide to access vehicles with confidence and ease. RentACar aspires to set a new standard for reliability in the car rental market.

## Project Roadmap

Define Smart Contract Variables and Structure

Variables:
Car: A struct containing car details (ID, model, price per day, availability status).
cars: A mapping to store all cars with unique IDs.
rentedCars: A mapping to track cars rented by users.
owner: Address of the contract owner for administrative tasks.
Modifiers:
onlyOwner: Restricts functions to the contract owner.

Develop Core Smart Contract Functions

addCar(uint id, string memory model, uint pricePerDay): Allows the owner to add new cars.
removeCar(uint id): Allows the owner to remove cars from the platform.
rentCar(uint id): Enables users to rent an available car.
returnCar(uint id): Allows users to return the rented car.
getRefund(uint id): Processes refunds for eligible transactions.

Implement Additional Features in Smart Contract

checkAvailability(uint id): Checks if a car is available for rent.
calculateRent(uint id, uint days): Calculates the total cost based on rental duration.
refundPolicy(uint id): Defines conditions under which a refund is issued.

Develop Front-End Interface

User Interface:
Car Listing: Display available cars with details.
Rent/Return Functionality: Buttons to rent and return cars.
Transaction History: Display user transactions and rental history.
Integration:
Use Web3.js or Ethers.js to interact with the smart contract.
Ensure secure communication between the front-end and the Scroll Blockchain.

Testing and Security Audits

Test all smart contract functions on a local blockchain environment (e.g., Ganache).
Perform security audits to identify and fix vulnerabilities.
Conduct user acceptance testing (UAT) for front-end and back-end integration.

Deployment and Maintenance

Deploy the smart contract to the Scroll Blockchain.
Launch the front-end for user access.
Monitor and maintain the system, ensuring updates and bug fixes as needed.

## The Tech We Use

Solidity and Scroll

## Smart Contract Address

0xac4d00BF3687231Bf66B3de2E4ddAEdb487378bf

## Setup Environment

RentACar is a decentralized car rental platform built on the Scroll Blockchain. This project allows users to rent cars, manage rentals, and handle refunds through a secure and transparent smart contract.

Installation Guide
Prerequisites
Node.js (version 16 or higher)
npm (Node Package Manager)
Solidity compiler (for smart contract development)
MetaMask or other Web3-compatible browser extension
Scroll Blockchain testnet setup (or mainnet for production)

Step 1: Clone the Repository

git clone https://github.com/Xersante/rentACar.git
cd rentacar

Step 2: Install Dependencies

npm install

Step 3: Compile the Smart Contracts
Make sure you have the Solidity compiler installed. You can compile the contracts using Truffle or Hardhat. For Truffle, use:

truffle compile
For Hardhat, use:

npx hardhat compile

Step 4: Deploy the Smart Contracts

Configure your deployment script with the appropriate Scroll Blockchain network settings. Then deploy the contracts:

truffle migrate --network scroll

Or, if using Hardhat:

npx hardhat run scripts/deploy.js --network scroll

Step 5: Set Up the Front-End

Configure the front-end application to connect to your deployed smart contract. Update the .env file with your smart contract address and other configuration details.

Step 6: Run the Front-End Application

npm start
Open your browser and navigate to http://localhost:3000 to interact with the RentACar application.

Additional Notes
Ensure your MetaMask or other Web3 wallet is connected to the correct Scroll Blockchain network.
For production deployment, make sure to adjust network settings and contract addresses accordingly.

License
This project is licensed under the MIT License.
