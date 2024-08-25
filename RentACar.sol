// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RentACar{
    // Variables
    address public owner;
    uint256 public constant refundAmountForFuel = 2 wei;
    uint256 public constant refundAmountForCleaning = 1 wei;
    uint256[] public cleanerLocationIds = [1, 2, 3];
    uint256 private lastId;

    // Structs
    struct Car {
        uint256 id;
        string model;
        uint256 rentalPeriod;
        uint256 pricePerDay;
        address customer;
        uint8 fuelRate; // Amount of fuel rating is from 1 to 5. (5 means that the amount of fuel is full.)
        uint8 cleaningRate; // Cleaning rating is from 1 to 10. (10 means that the car is very clean.)
        bool isAvailable;
    }

    // Maps
    mapping (uint256 => Car) public cars;

    // Modifiers
    modifier onlyOwner(){
        require(owner == msg.sender, "Only owner can use!");
        _;
    }

    modifier onlyCustomer(uint256 carId){
        require(msg.sender == cars[carId].customer);
        _;
    }

    modifier onlyAvailable(uint256 carId){
        require(cars[carId].isAvailable, "The car has to be available!");
        _;
    }

    modifier onlyExactMoney(uint256 carId, uint256 _rentalPeriod){
        require(msg.value == (cars[carId].pricePerDay * _rentalPeriod), "You do not have enough money!");
        _;
    }

    modifier onlyCorrectLocation(uint256 locationId){
        require(hasLocation(locationId), "This location is not suitable!");
        _;
    }

    modifier onlyLowCleaningRate(uint256 carId){
        require(cars[carId].cleaningRate == 1, "Car is already clean.");
        _;
    }

    //Events
    event CarAdded(uint256 indexed  carId, string _model);
    event CarRemoved(uint256 indexed carId, string _model);
    event CarRented(uint256 indexed carId, string _model, address customerAddress);
    event CarAvailable(uint256 indexed carId, string _model);
    event CarLeft(uint256 indexed carId, string _model);
    event CarCleaned(uint256 indexed carId, string _model, uint8 _cleaningRate);
    event CarFilledFuel(uint256 indexed carId, string _model, uint8 _fuelRate);
    event CarPriceUpdated(uint256 indexed carId, string _model, uint256 _pricePerDay);
    event LocationAdded(uint256 indexed locationId);
    event LocationRemoved(uint256 indexed locationId);
    
    // Constructor
    constructor() {
        owner = msg.sender;
        cars[1] = Car(1, "Clio", 0, 3 wei, address(0), 5, 10, true);
        cars[2] = Car(2, "Astra", 0, 5 wei, address(0), 5, 10, true);
        cars[3] = Car(3, "Mustang", 0, 7 wei, address(0), 5, 10, true);
        lastId = 3;
    }

    // Query Functions
    function hasLocation(uint256 locationId) internal view returns (bool) {
        for(uint256 i = 0; i < cleanerLocationIds.length; i++){
            if (locationId == cleanerLocationIds[i]){
                return true;
            }
        }

        return false;
    }

    // Execute Functions
    function addCar(string memory _model, uint256 _rentalPeriod, uint256 _pricePerDay, uint8 _fuelRate, uint8 _cleaningRate, bool _isAvailabe) public onlyOwner{
        lastId ++;
        cars[lastId] = Car(lastId, _model, _rentalPeriod, _pricePerDay, address(0), _fuelRate, _cleaningRate, _isAvailabe);
        
        emit CarAdded(lastId, cars[lastId].model);
    }

    function removeCar(uint256 carId) public onlyOwner{
        cars[carId].isAvailable = false;

        emit CarRemoved(carId, cars[carId].model);
    }
    
    function addLocation(uint256 locationId) public onlyOwner{
        cleanerLocationIds.push(locationId);
    }

    function removeLocation(uint256 locationId) public onlyOwner{
        uint indexToRemove = cleanerLocationIds.length;
        
        for (uint i = 0; i < cleanerLocationIds.length; i++) {
            if (cleanerLocationIds[i] == locationId) {
                indexToRemove = i;
                break;
            }
        }

        require(indexToRemove < cleanerLocationIds.length, "Location not found in the array");

        cleanerLocationIds[indexToRemove] = cleanerLocationIds[cleanerLocationIds.length - 1];
        cleanerLocationIds.pop();
    }

    function updateCarPrice(uint256 carId, uint256 newPrice) public onlyOwner {
        cars[carId].pricePerDay = newPrice;

        emit CarPriceUpdated(carId, cars[carId].model, newPrice);
    }

    function rentCar(uint256 carId, uint256 _rentalPeriod) external payable onlyAvailable(carId) onlyExactMoney(carId, _rentalPeriod){
        cars[carId].isAvailable = false;
        cars[carId].rentalPeriod = block.timestamp + (_rentalPeriod * 1 days);
        cars[carId].customer = msg.sender;
        if (cars[carId].cleaningRate > 1){
            cars[carId].cleaningRate --;
        }
        
        emit CarRented(cars[carId].id, cars[carId].model, cars[carId].customer);
    }

    function extendRentalPeriod(uint256 carId, uint256 _extendPeriod) external payable onlyCustomer(carId) onlyExactMoney(carId, _extendPeriod){
        cars[carId].rentalPeriod += (_extendPeriod * 1 days);
    }

    function leaveCar(uint256 carId) public onlyCustomer(carId){
        cars[carId].customer = address(0);
        cars[carId].isAvailable = true;

        emit CarLeft(carId, cars[carId].model);
    }

    function getCarBack(uint256 carId) external onlyOwner{
        require(block.timestamp > cars[carId].rentalPeriod, "The rental period has not ended yet.");

        cars[carId].customer = address(0);
        cars[carId].isAvailable = true;

        emit CarLeft(carId, cars[carId].model);
    }

    function refundFromCleaning(uint256 carId, uint256 locationId) external onlyCorrectLocation(locationId) onlyLowCleaningRate(carId){
        require(msg.sender == cars[carId].customer || msg.sender == owner, "This car was not rented by you!");
        require(refundAmountForCleaning <= address(this).balance, "Not enough balance in the contract");

        if(msg.sender == cars[carId].customer){
            (bool success, ) = msg.sender.call{value: refundAmountForCleaning}("");
            require(success, "Failed to send Ether");
        }

        cars[carId].cleaningRate = 10;

        emit CarCleaned(carId, cars[carId].model, cars[carId].cleaningRate);
        leaveCar(carId);
    }

    function refundFromFuel(uint256 carId, uint8 currentFuelRate) external {
        cars[carId].fuelRate = currentFuelRate;
        require(currentFuelRate == 1, "Car already has fuel.");
        require(msg.sender == cars[carId].customer || msg.sender == owner, "This car was not rented by you!");
        require(refundAmountForFuel <= address(this).balance, "Not enough balance in the contract");

        if(msg.sender == cars[carId].customer){
            (bool success, ) = msg.sender.call{value: refundAmountForFuel}("");
            require(success, "Failed to send Ether");
        }
        
        cars[carId].fuelRate = 5;

        emit CarFilledFuel(carId, cars[carId].model, cars[carId].fuelRate);
        leaveCar(carId);

    }
}