// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/bitwise.sol";

contract Uint256BitmapTest is Test {
    Uint256Bitmap private bitmapContract;

    function setUp() public {
        bitmapContract = new Uint256Bitmap(); // Deploy the contract
    }

    function testStoreAndRetrieveByte() public {
        uint8 index = 5;
        uint8 value = 0xAB;

        bitmapContract.storeByte(value, index);
        uint8 retrievedValue = bitmapContract.getByte(index);

        assertEq(
            retrievedValue,
            value,
            "Stored byte does not match retrieved byte"
        );
    }

    function testRetrieveAllBytes() public {
        uint8[32] memory expectedValues;

        // Store different values at each index
        for (uint8 i = 0; i < 32; i++) {
            expectedValues[i] = i * 3; // Assign some test values
            bitmapContract.storeByte(expectedValues[i], i);
        }

        uint8[32] memory retrievedValues = bitmapContract.getAllBytes();

        for (uint8 i = 0; i < 32; i++) {
            assertEq(
                retrievedValues[i],
                expectedValues[i],
                "Mismatch in getAllBytes"
            );
        }
    }

    function testStoreAtFirstAndLastSlot() public {
        bitmapContract.storeByte(0x11, 0);
        bitmapContract.storeByte(0xFF, 31);

        assertEq(bitmapContract.getByte(0), 0x11, "First byte incorrect");
        assertEq(bitmapContract.getByte(31), 0xFF, "Last byte incorrect");
    }

    function testOutOfRangeIndexShouldFail() public {
        vm.expectRevert("Index out of range");
        bitmapContract.storeByte(0xAA, 32);

        vm.expectRevert("Index out of range");
        bitmapContract.getByte(32);
    }
}
