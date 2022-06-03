pragma solidity ^0.8.0;
interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);//我批准你用的钱，不过钱还是在我这里 

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);//类似亲属卡 钱在我这里
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);//把批准的钱转移

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event drinkBuy(address buyer,string drinkname,uint num);

    
}

contract ERC20_Drink_G12{
    //  以下的代币性质皆可用构造器初始化 但是是小组作业 没硬性要求 就直接初始化了
    string public constant name = "Drink_G12";//代币名称
    string public constant symbol = "DR_G12";//代币符号 类似于￥ $
    uint8 public constant decimals = 2;//精确到小数点后两位
    uint256 totalSupply_ = 1000000000;//总共代币数量：一千万个币  相当于一百万

    mapping(address => uint256) balances;//用地址查询余额的映射
    mapping(address => mapping (address => uint256)) allowed;//用地址查询前一个映射：arr1给arr2了多少钱批准
    mapping(string => _drink) drink_struct;//饮料名称与饮料结构体的映射
    // mapping(string => uint256) drinkPrice;//饮料到价格的映射
    // mapping(string => uint256) drinksTotal;//饮料数量
    // mapping(address => string) buyerDrinkK;
    mapping(address => mapping(string => uint)) buyerDrink;////购买饮料名字和购买数量

    constructor () {
        balances[msg.sender] = totalSupply_;
    }
    
    modifier userBalances() {
    require(balances[msg.sender]>0);
    _;
    }

    //基本的转账功能
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public userBalances override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public userBalances override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

       
}

contract Drink_Buy{
    struct _drink{
        string drinkName;//名称
        uint drinkTotal;//数量  
        uint drinkPrice;//价格
    }

    _drink drink_1 = _drink("maiDong",100,40);
    _drink drink_2 = _drink("wangLaoJi",100,30);
    _drink drink_3 = _drink("lvCha",100,30);
    _drink drink_4 = _drink("hongCha",100,30);
    _drink drink_5 = _drink("xianChengZhi",100,20);
    _drink drink_6 = _drink("yiBao",100,10);
    _drink drink_7 = _drink("yingYangKuaiXian",100,40);

    drink_struct[maiDong]=drink_1;
    drink_struct[wangLaoJi]=drink_2;
    drink_struct[lvCha]=drink_3;
    drink_struct[hongCha]=drink_4;
    drink_struct[xianChengZhi]=drink_5;
    drink_struct[yiBao]=drink_6;
    drink_struct[yingYangKuaiXian]=drink_7;

    //买水功能
    function buyDrink(string drinkname,uint num) public userBalances returns (bool){
        require(drink_struct[drinkname].drinkTotal>=num);
        require(balances[msg.sender]>=(num*drink_struct[drinkname].drinkPrice));
        balances[msg.sender]=balances[msg.sender]-num*drink_struct[drinkname].drinkPrice;
        drink_struct[drinkname].drinkTotal=drink_struct[drinkname].drinkTotal-num;
        buyerDrink[msg.sender][drinkname]=num;
        emit drinkBuy(msg.sender,drinkname,num);
        return true;


    }
}