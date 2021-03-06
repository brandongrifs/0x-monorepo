/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity ^0.4.24;

contract LibOrder {

    bytes32 constant DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(
        "DomainSeparator(address contract)"
    );

    bytes32 constant ORDER_SCHEMA_HASH = keccak256(
        "Order(",
        "address makerAddress,",
        "address takerAddress,",
        "address feeRecipientAddress,",
        "address senderAddress,",
        "uint256 makerAssetAmount,",
        "uint256 takerAssetAmount,",
        "uint256 makerFee,",
        "uint256 takerFee,",
        "uint256 expirationTimeSeconds,",
        "uint256 salt,",
        "bytes makerAssetData,",
        "bytes takerAssetData,",
        ")"
    );

    struct Order {
        address makerAddress;
        address takerAddress;
        address feeRecipientAddress;
        address senderAddress;
        uint256 makerAssetAmount;
        uint256 takerAssetAmount;
        uint256 makerFee;
        uint256 takerFee;
        uint256 expirationTimeSeconds;
        uint256 salt;
        bytes makerAssetData;
        bytes takerAssetData;
    }

    struct OrderInfo {
        // See LibStatus for a complete description of order statuses
        uint8 orderStatus;
        // Keccak-256 EIP712 hash of the order
        bytes32 orderHash;
        // Amount of order that has been filled
        uint256 orderTakerAssetFilledAmount;
    }

    /// @dev Calculates Keccak-256 hash of the order.
    /// @param order The order structure.
    /// @return Keccak-256 EIP712 hash of the order.
    function getOrderHash(Order memory order)
        internal
        view
        returns (bytes32 orderHash)
    {
        // TODO: EIP712 is not finalized yet
        // Source: https://github.com/ethereum/EIPs/pull/712
        orderHash = keccak256(
            DOMAIN_SEPARATOR_SCHEMA_HASH,
            keccak256(address(this)),
            ORDER_SCHEMA_HASH,
            keccak256(
                order.makerAddress,
                order.takerAddress,
                order.feeRecipientAddress,
                order.senderAddress,
                order.makerAssetAmount,
                order.takerAssetAmount,
                order.makerFee,
                order.takerFee,
                order.expirationTimeSeconds,
                order.salt,
                keccak256(order.makerAssetData),
                keccak256(order.takerAssetData)
            )
        );
        return orderHash;
    }
}
