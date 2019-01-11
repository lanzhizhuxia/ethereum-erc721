pragma solidity 0.5.1;

import "https://github.com/lanzhizhuxia/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";

/**
 * @dev Minority decision.
 */
contract MinorityDecisionSale is
NFTokenMetadata,
Ownable
{

  uint8 public constant decimals = 18;

  uint256 public constant LIMIT  = 10 ** uint256(decimals);
  // 锻造上限
  uint8 public constant PRIVATE_SALE_AMOUNT = 3;
  // 所有锻造RED总数
  uint public totalRedSalesReleased;


  /**
   * @dev Contract constructor. Sets metadata extension `name` and `symbol`.
   */
  constructor()
  public
  {
    nftName = "Minority decision";
    nftSymbol = "MD";
  }

  /**
   * @dev Mints a new NFT.
   * @param _to The address that will own the minted NFT.
   */
  function mintRed(
    address _to

  )
  external payable
  onlyOwner
  {
    // 计算折扣后实际 token 数量
    uint256 limitValue = 1 * LIMIT;
    require(msg.value == limitValue, " The payment amount is wrong.");

    // 检查发行上限
    totalRedSalesReleased = totalRedSalesReleased.add(1);
    require(totalRedSalesReleased <= PRIVATE_SALE_AMOUNT, "Mint exceeded limitation.");


    uint tokenId = uint(keccak256(now, msg.sender)) % LIMIT;
    super._mint(_to, tokenId);
    super._setTokenUri(_tokenId, "RED");
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

    super._burn(_tokenId);
  }

  /**
 * @dev 返回红方票数
 */
  function countRed(
  )
  external
  view
  returns (uint256)
  {

    return PRIVATE_SALE_AMOUNT -totalRedSalesReleased - totalRedBurn;
  }

}