pragma solidity 0.5.1;

import ".//nf-token.sol";
import "./erc721-metadata.sol";
import "./erc721-enumerable.sol";
import "../ownership/ownable.sol";


/**
 * @dev Optional metadata implementation for ERC-721 non-fungible token standard.
 */
contract MinorityDecisionSale is
NFToken,
Ownable,
ERC721Metadata,
ERC721Enumerable
{

  /**
   * @dev A descriptive name for a collection of NFTs.
   */
  string internal nftName;

  /**
   * @dev An abbreviated name for NFTokens.
   */
  string internal nftSymbol;

  /**
   * @dev Mapping from NFT ID to metadata uri.
   */
  mapping (uint256 => string) internal idToUri;

  /**
   * @dev Array of all NFT IDs.
   */
  uint256[] internal tokens;

  /**
   * @dev Mapping from token ID its index in global tokens array.
   */
  mapping(uint256 => uint256) internal idToIndex;

  /**
   * @dev Mapping from owner to list of owned NFT IDs.
   */
  mapping(address => uint256[]) internal ownerToIds;

  /**
   * @dev Mapping from NFT ID to its index in the owner tokens list.
   */
  mapping(uint256 => uint256) internal idToOwnerIndex;

  /**
  * @dev A mapping from NFT ID to the address that owns it.
  */
  mapping (uint256 => address payable) private idToOwnerPayable;



  uint8 public constant decimals = 18;

  uint256 public constant LIMIT  = 10 ** uint256(decimals);
  // 锻造上限
  uint8 public constant PRIVATE_SALE_AMOUNT = 3;
  // 所有锻造RED总数
  uint public totalRedSalesReleased = 0;
  // 所有销毁RED总数
  uint public totalRedBurn;

  // 所有锻造BLUE总数
  uint public totalBlueSalesReleased = 3;
  // 所有销毁BLUE总数
  uint public totalBlueBurn;

  // 所有锻造GREEN总数
  uint public totalGreenSalesReleased = 6;
  // 所有销毁GREEN总数
  uint public totalGreenBurn;

  // 合约创建的时间戳
  uint256 public contractStartTime;

  // 一周时间的时间戳增量常数
  uint256 public constant TIMESTAMP_INCREMENT_OF_WEEK  = 604800;
  // Owner 的钱包地址
  address payable ownerWallet;


  /**
   * @dev Contract constructor.
   * @notice When implementing this contract don't forget to set nftName and nftSymbol.
   */
  constructor()
  public
  {
    supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
    supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
    nftName = "Minority decision";
    nftSymbol = "MD";
    contractStartTime = block.timestamp;
    ownerWallet = msg.sender;
  }

  /**
   * @dev Returns a descriptive name for a collection of NFTokens.
   * @return Representing name.
   */
  function name()
  external
  view
  returns (string memory _name)
  {
    _name = nftName;
  }

  /**
   * @dev Returns an abbreviated name for NFTokens.
   * @return Representing symbol.
   */
  function symbol()
  external
  view
  returns (string memory _symbol)
  {
    _symbol = nftSymbol;
  }



  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   */
  function mintRed(
    address payable _to

  )
  external payable

  {
    // 计算折扣后实际 token 数量
    uint256 limitValue = 1 * LIMIT;
    require(msg.value == limitValue, " The payment amount is wrong.");

    // 检查发行上限
    totalRedSalesReleased = totalRedSalesReleased.add(1);
    require(totalRedSalesReleased <= PRIVATE_SALE_AMOUNT, "Mint exceeded limitation.");

    _mint(_to, totalRedSalesReleased);
    _setTokenUri(totalRedSalesReleased, "RED");
    idToOwnerPayable[totalGreenSalesReleased] = _to;
  }

  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   */
  function mintBlue(
    address payable _to

  )
  external payable

  {
    // 计算折扣后实际 token 数量
    uint256 limitValue = 1 * LIMIT;
    require(msg.value == limitValue, " The payment amount is wrong.");

    // 检查发行上限
    totalBlueSalesReleased = totalBlueSalesReleased.add(1);
    require(totalBlueSalesReleased <= 2 * PRIVATE_SALE_AMOUNT, "Mint exceeded limitation.");

    _mint(_to, totalBlueSalesReleased);
    _setTokenUri(totalBlueSalesReleased, "BLUE");
    idToOwnerPayable[totalBlueSalesReleased] = _to;
  }

  /**
  * @dev Mints a new NFT.
  * @param _to The address that will own the minted NFT.
  */
  function mintGreen(
    address payable _to

  )
  external payable

  {
    // 计算折扣后实际 token 数量
    uint256 limitValue = 1 * LIMIT;
    require(msg.value == limitValue, " The payment amount is wrong.");

    // 检查发行上限
    totalGreenSalesReleased = totalGreenSalesReleased.add(1);
    require(totalGreenSalesReleased <= 3 * PRIVATE_SALE_AMOUNT, "Mint exceeded limitation.");

    _mint(_to, totalGreenSalesReleased);
    _setTokenUri(totalGreenSalesReleased, "GREEN");
    idToOwnerPayable[totalGreenSalesReleased] = _to;
  }

  /**
   * @dev Removes a NFT from owner.
   * @param _tokenId Which NFT we want to remove.
   */
  function burn(
    uint256 _tokenId
  )
  external
  canOperate(_tokenId)
  {

    _burn(_tokenId);

    if( _tokenId<=300){
      totalRedBurn=totalRedBurn.add(1);
    }else if(_tokenId<=600){
      totalRedBurn=totalBlueBurn.add(1);
    }else {
      totalRedBurn=totalGreenBurn.add(1);
    }
  }

  /**
   * @dev 返回red票数
   */
  function countRed(
  )
  public
  view
  returns (uint256)
  {

    return totalRedSalesReleased - totalRedBurn;
  }

  /**
   * @dev 返回blue票数
   */
  function countBlue(
  )
  public
  view
  returns (uint256)
  {

    return totalBlueSalesReleased - totalBlueBurn -3;
  }

  /**
   * @dev 返回green票数
   */
  function countGreen(
  )
  public
  view
  returns (uint256)
  {

    return totalGreenSalesReleased - totalGreenBurn - 6;
  }

  /**
   * @dev A distinct URI (RFC 3986) for a given NFT.
   * @param _tokenId Id for which we want uri.
   * @return URI of _tokenId.
   */
  function tokenURI(
    uint256 _tokenId
  )
  external
  view
  validNFToken(_tokenId)
  returns (string memory)
  {
    return idToUri[_tokenId];
  }

  /**
  * @dev Returns the count of all existing NFTokens.
  * @return Total supply of NFTs.
  */
  function totalSupply()
  external
  view
  returns (uint256)
  {
    return tokens.length;
  }

  /**
   * @dev Returns NFT ID by its index.
   * @param _index A counter less than `totalSupply()`.
   * @return Token id.
   */
  function tokenByIndex(
    uint256 _index
  )
  external
  view
  returns (uint256)
  {
    require(_index < tokens.length);
    return tokens[_index];
  }

  /**
   * @dev returns the n-th NFT ID from a list of owner's tokens.
   * @param _owner Token owner's address.
   * @param _index Index number representing n-th token in owner's list of tokens.
   * @return Token id.
   */
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
  external
  view
  returns (uint256)
  {
    require(_index < ownerToIds[_owner].length);
    return ownerToIds[_owner][_index];
  }


  // 返回_owner拥有的所有猫猫的id数组
  function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
    // 获得_owner拥有的数量
    require(_owner != address(0));
    uint256 tokenCount = _getOwnerNFTCount(_owner);

    // 判断数量是否为0
    if (tokenCount == 0) {
      // 如果该_owner没有，返回空数组
      return new uint256[](0);
    } else {
      // 如果该_owner有
      // 声明并初始化一个返回值result，长度为tokenCount
      uint256[] memory result = new uint256[](tokenCount);
      // 当前所有的卡数量
      uint256 totalCard = 3 * PRIVATE_SALE_AMOUNT;
      // 循环的初始值
      uint256 resultIndex = 0;

      // 所有的卡card都有ID从1增加到totalCats
      uint256 cardId;

      // 从1开始循环遍历所有的totalCats
      for (cardId = 1; cardId <= totalCard; cardId++) {
        // 判断当前catId的拥有者是否为_owner
        if (idToOwner[cardId] == _owner) {
          // 如果是，将catId放入result数组resultIndex位置
          result[resultIndex] = cardId;
          // resultIndex加1
          resultIndex++;
        }
      }

      // 返回result
      return result;
    }
  }


  /**
   * @dev 检查私募是否已经结束
   */
  function isPrivateSaleFinished() public view returns (bool) {
    bool b1=block.timestamp > contractStartTime + TIMESTAMP_INCREMENT_OF_WEEK;
    bool b2= 3*PRIVATE_SALE_AMOUNT == tokens.length;

    return b1 || b2;

  }

  /**
   * @dev 查看合约余额
   */
  function getAddBalanceOf() public view returns (uint) {
    return address(this).balance;
  }



  /**
  * @dev 资金分红
  */
  function investmentDividend() public payable onlyOwner {


    uint countR = countRed();
    uint countB = countBlue();
    uint countG = countGreen();

    uint dividend = getAddBalanceOf().mul(10).div(7);
    uint dividendUnits;


    if(countR<countB&&countR<countG){
      //RED win
      dividendUnits=dividend/countR;
      uint tokenId;
      // 从1开始循环遍历所有
      for (tokenId = 1; tokenId <= PRIVATE_SALE_AMOUNT; tokenId++) {

        //address payable owner = idToOwner[tokenId];
        // // 判断当前tokenId拥有者是否为_owner
        // if (address(0) != owner) {
        //   //address(this).tra
        //   //super.transfer(owner,1000);
        //   owner.transfer(dividendUnits);


        // }
      }

    } else if(countB<countR&&countB<countG){
      //BLUE win
      dividendUnits=dividend/countB;

    } else if(countG<countR&&countG<countB){
      //GREEN win
      dividendUnits=dividend/countG;

    } else{
      //No winner
      ownerWallet.transfer(address(this).balance);

    }


  }

  /**
   * @dev 查看领先者
   */
  function checkWinner() public view returns (string memory) {

    uint countR = countRed();
    uint countB = countBlue();
    uint countG = countGreen();

    string memory res;

    if(countR<countB&&countR<countG){
      res= "RED";
    } else if(countR==countB&&countR<countG){
      res= "RED&BLUE";
    } else if(countR==countG&&countR<countB){
      res= "RED&GREEN";
    } else if(countB<countR&&countB<countG){
      res= "BLUE";
    } else if(countB==countG&&countB<countR){
      res= "BLUE&GREEN";
    } else if(countG<countR&&countG<countB){
      res= "GREEN";
    } else{
      res= "No winner";
    }

    return res;
  }

  /**
   * @dev Mints a new NFT.
   * @notice This is a private function which should be called from user-implemented external
   * mint function. Its purpose is to show and properly initialize data structures when using this
   * implementation.
   * @param _to The address that will own the minted NFT.
   * @param _tokenId of the NFT to be minted by the msg.sender.
   */
  function _mint(
    address _to,
    uint256 _tokenId
  )
  internal
  {
    super._mint(_to, _tokenId);
    uint256 length = tokens.push(_tokenId);
    idToIndex[_tokenId] = length - 1;
  }

  /**
   * @dev Burns a NFT.
   * @notice This is a internal function which should be called from user-implemented external
   * burn function. Its purpose is to show and properly initialize data structures when using this
   * implementation.
   * @param _tokenId ID of the NFT to be burned.
   */
  function _burn(
    uint256 _tokenId
  )
  internal
  {
    super._burn(_tokenId);

    if (bytes(idToUri[_tokenId]).length != 0)
    {
      delete idToUri[_tokenId];
    }

    uint256 tokenIndex = idToIndex[_tokenId];
    uint256 lastTokenIndex = tokens.length - 1;
    uint256 lastToken = tokens[lastTokenIndex];

    tokens[tokenIndex] = lastToken;

    tokens.length--;
    // This wastes gas if you are burning the last token but saves a little gas if you are not.
    idToIndex[lastToken] = tokenIndex;
    idToIndex[_tokenId] = 0;



  }

  /**
   * @dev Set a distinct URI (RFC 3986) for a given NFT ID.
   * @notice this is a internal function which should be called from user-implemented external
   * function. Its purpose is to show and properly initialize data structures when using this
   * implementation.
   * @param _tokenId Id for which we want uri.
   * @param _uri String representing RFC 3986 URI.
   */
  function _setTokenUri(
    uint256 _tokenId,
    string memory _uri
  )
  internal
  validNFToken(_tokenId)
  {
    idToUri[_tokenId] = _uri;
  }

  /**
    * @dev Removes a NFT from an address.
    * @notice Use and override this function with caution. Wrong usage can have serious consequences.
    * @param _from Address from wich we want to remove the NFT.
    * @param _tokenId Which NFT we want to remove.
    */
  function _removeNFToken(
    address _from,
    uint256 _tokenId
  )
  internal
  {
    require(idToOwner[_tokenId] == _from);
    delete idToOwner[_tokenId];

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_from].length - 1;

    if (lastTokenIndex != tokenToRemoveIndex)
    {
      uint256 lastToken = ownerToIds[_from][lastTokenIndex];
      ownerToIds[_from][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    ownerToIds[_from].length--;
  }


  /**
   * @dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable
   * extension to remove double storage(gas optimization) of owner nft count.
   * @param _owner Address for whom to query the count.
   * @return Number of _owner NFTs.
   */
  function _getOwnerNFTCount(
    address _owner
  )
  internal
  view
  returns (uint256)
  {
    return ownerToIds[_owner].length;
  }

}
