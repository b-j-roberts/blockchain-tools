pragma solidity >=0.8.2 <0.9.0;

contract CurlContract {
    uint256 public value;
    uint256 public value2;
    string public val;

    constructor() {
        value = 0;
        value2 = 10;
    }

    function updateValue() external {
      value2 = value2 + 1;
      string memory _url = "http://localhost:5090/integer";
      // Call precompile at address 20 with string as byte calldata
      //(bool ok, bytes memory out) = address(0x14).staticcall(abi.encode(_url));
      (bool ok, bytes memory out) = address(0x14).staticcall(bytes(_url));
      require(ok, "call failed");
      //value = abi.decode(out, (uint256));
      val = string(out);
      value2 = stringToUint(val);
    }

    function stringToUint(string memory _str) public pure returns (uint256) {
        bytes memory bStr = bytes(_str);
        uint256 uintValue = 0;
        uint256 decimals = 1;

        for (uint256 i = bStr.length; i > 0; i--) {
            uint8 digit = uint8(bStr[i - 1]) - 48; // Convert ASCII to digit
            require(digit <= 9, "Invalid character in string");
            
            uintValue += digit * decimals;
            decimals *= 10;
        }

        return uintValue;
    }

    function getCurlContractValue() external view returns (uint256) {
        return value;
    }

    function getCurlContractValue2() external view returns (uint256) {
        return value2;
    }

    function getCurlContractVal() external view returns (string memory) {
        return val;
    }
}
