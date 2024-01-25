// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PharmaEth is ERC721, AccessControl {
    bytes32 public constant FARMER_ROLE = keccak256("FARMER_ROLE");
    bytes32 public constant PROCESSING_ROLE = keccak256("PROCESSING_ROLE");
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant DISTRIBUTION_ROLE = keccak256("DISTRIBUTION_ROLE");
    uint256 private _nextTokenId;

    event tokenCreated(address minter, uint tokenID);
    event farmerDataSet(address farmer, string info, SupplyInfo);
    event processingDataSet(address processor, string info, SupplyInfo);
    event manufactorDataSet(address processor, string info, SupplyInfo);
    event distrobutorDataSet(address processor, string info, SupplyInfo);

    constructor(
        address processor,
        address manufactoter,
        address distrobution
    ) ERC721("PharmaEth", "PNFT") {
        _grantRole(FARMER_ROLE, msg.sender);
        _grantRole(PROCESSING_ROLE, processor);
        _grantRole(MANUFACTURER_ROLE, manufactoter);
        _grantRole(DISTRIBUTION_ROLE, distrobution);
    }

    struct SupplyInfo {
        string farmerInfo;
        string processingInfo;
        string manufactoringInfo;
        string distrobutionInfo;
    }

    mapping(uint => SupplyInfo) public supplyChainInfo;
    mapping(address => bool) public hasSetData;

    function safeMint() public onlyRole(FARMER_ROLE) {
        uint256 tokenId = _nextTokenId++;

        SupplyInfo memory newSupplyInfo = SupplyInfo({
            farmerInfo: "",
            processingInfo: "",
            manufactoringInfo: "",
            distrobutionInfo: ""
        });

        supplyChainInfo[tokenId] = newSupplyInfo;
        _safeMint(msg.sender, tokenId);
        emit tokenCreated(msg.sender, tokenId);
    }

    function setFarmerInfo(
        uint tokenID,
        string memory data
    ) public onlyRole(FARMER_ROLE) {
        SupplyInfo storage current = supplyChainInfo[tokenID];

        require(!hasSetData[msg.sender], "user has already set data");
        current.farmerInfo = data;
        hasSetData[msg.sender] = true;

        emit farmerDataSet(msg.sender, data, current);
    }

    function setProcessingInfo(
        uint tokenID,
        string memory data
    ) public onlyRole(PROCESSING_ROLE) {
        SupplyInfo storage current = supplyChainInfo[tokenID];

        require(!hasSetData[msg.sender], "user has already set data");
        current.processingInfo = data;
        hasSetData[msg.sender] = true;

        emit processingDataSet(msg.sender, data, current);
    }

    function setManufactoringInfo(
        uint tokenID,
        string memory data
    ) public onlyRole(MANUFACTURER_ROLE) {
        SupplyInfo storage current = supplyChainInfo[tokenID];

        require(!hasSetData[msg.sender], "user has already set data");
        current.manufactoringInfo = data;
        hasSetData[msg.sender] = true;

        emit manufactorDataSet(msg.sender, data, current);
    }

    function setDistrobutingInfo(
        uint tokenID,
        string memory data
    ) public onlyRole(DISTRIBUTION_ROLE) {
        SupplyInfo storage current = supplyChainInfo[tokenID];

        require(!hasSetData[msg.sender], "user has already set data");
        current.distrobutionInfo = data;
        hasSetData[msg.sender] = true;

        emit distrobutorDataSet(msg.sender, data, current);
    }

    function getNFT(uint ID) public view returns (SupplyInfo memory) {
        return supplyChainInfo[ID];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
