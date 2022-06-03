# 我的博客

---

GITHUBIO:[GOODFLY'S BLOG](https://goodflyo.github.io/)

SERVER:[GOODFLY'S BLOG](http://www.goodfly.vip/)

---

# ECR20_Drink

> 基于ERC20的饮料售卖系统

# 加密货币应用开发实践

## 一、基于ERC20标准的数字积分系统设计

> example:数字藏品积分系统，社交媒体积分系统

> 以PPT和代码截图的形式进行提交

---

### 学习目标

1. 掌握如何应用ERC20标准实现一套数字积分系统。
2. 掌握如何根据具体的应用场景制订出自己的数字积分系统积分分配发行机制。
3. 制作出该数字积分系统的使用介绍PPT，以及你为什么用这样的数字积分系统积分分配发行机制。
4. ERC20标准与ERC721标准的互操作性。

---

### 实验步骤

1.	基于ERC20标准制定并实现一套数字积分系统。
2.	部署于Ropsten测试链上。
3.	用PPT写明该积分系统设计的机制及积分分配的原理。
4.	每个组员账号都需要参与积分分配或转移，并截图放于PPT上。
5.	能额外设计出ERC20标准与ERC721标准的的兑换机制及代码有加分。
6.	同学们有任何创新的应用场景或整体的设计都能有加分。

---

### 适用场景

> 使用ERC20的代币购买饮料
>
> 饮料由名字、价格和剩余量组成
>
> 别人可以购买 生产商可以上新（数量或饮料种类）

---

### 合约部署

>**合约地址**:0x01f4E0c6D43f1bEAf545f70de32b28D7Ab7F80d2
>**部署人**：0x3a284942f74F96a4efFcCEaf4C294A36F70E3712

---

### 代币性质

> 与人民币比例：1：10
>
> 也就是30个代币相当于3￥

```solidity
//  以下的代币性质皆可用构造器初始化 但是是小组作业 没硬性要求 就直接初始化了
    string public constant name = "Drink_G12";//代币名称
    string public constant symbol = "DR12";//代币符号 类似于￥ $
    uint8 public constant decimals = 2;//精确到小数点后两位
    uint256 totalSupply_ = 1000000;//总共代币数量：一万个币  相当于一千
    address zhou = 0x3a284942f74F96a4efFcCEaf4C294A36F70E3712;//生产商地址


    mapping(address => uint256) balances;//用地址查询余额的映射
    mapping(address => mapping (address => uint256)) allowed;

```

---

### 饮料种类

```solidity
string maiDong="maiDong";
    string wangLaoJi = "wangLaoJi";
    string lvCha = "lvCha";
    string hongCha = "hongCha";
    string xianChengZhi = "xianChengZhi";
    string yiBao = "yiBao";
    string yingYangKuaiXian = "yingYangKuaiXian";

constructor() {
    DrinkNN[maiDong]=100;
    DrinkNN[wangLaoJi]=100;
    DrinkNN[lvCha]=100;
    DrinkNN[hongCha]=100;
    DrinkNN[xianChengZhi]=100;
    DrinkNN[yiBao]=100;
    DrinkNN[yingYangKuaiXian]=100;


    DrinkNP[maiDong]=40;
    DrinkNP[wangLaoJi]=30;
    DrinkNP[lvCha]=30;
    DrinkNP[hongCha]=30;
    DrinkNP[xianChengZhi]=20;
    DrinkNP[yiBao]=10;
    DrinkNP[yingYangKuaiXian]=40;
}
```

---

### 自定义功能

```solidity
//买水功能
    function _buyDrink(string memory drinkname,uint num) public  returns (bool){
        require(DrinkNN[drinkname]>=num);
        require(balances[msg.sender]>=(num*DrinkNP[drinkname]));
        transfer(OwnerDrink,num*DrinkNP[drinkname]);//这个的调用者是msg.sender
        DrinkNN[drinkname]=DrinkNN[drinkname]-num;
        BuyerName[msg.sender]=drinkname;
        BuyerDrink[msg.sender][drinkname]=num;
        Point[msg.sender]=Point[msg.sender]+num;
        emit _drinkBuy(msg.sender,drinkname,num);
        return true;
    }
    //生产商更新饮料
    function _updateDrink(string memory name,uint price,uint number) public  returns (bool){
        require(msg.sender==OwnerDrink);//只有生产商可以发布
        DrinkNP[name]=price;
        DrinkNN[name]=number;
        return true;

    }
    //积分兑换
    function PointSwap(uint eggNum)public returns (bool){
        require(Point[msg.sender]>=eggNum*10);
        Point[msg.sender]=Point[msg.sender]-eggNum*10;
        egg[msg.sender]=egg[msg.sender]+eggNum;
        return true;
    }

    //查询饮料剩余
    function calDrinkNum(string memory drinkna) public view returns (uint){
        return DrinkNN[drinkna];
    }
    //查询饮料价格
    function calDrinkPrice(string memory drinkna1) public view returns (uint){
        return DrinkNP[drinkna1];
    }
    
    //查询积分
    function calPoint(address add) public view returns (uint){
        return Point[add];

    }
    //查询鸡蛋
    function calEgg(address add) public view returns (uint){
        return egg[add];
    }
    //查看这个人买了什么
    function calBuyerDrink(address add) public view returns (string memory drinkname,uint drinknumber){
        return (BuyerName[msg.sender],BuyerDrink[msg.sender][BuyerName[msg.sender]]);
        // drinkname=BuyerName[msg.sender];
        // drinknumber=BuyerDrink[msg.sender][BuyerName[msg.sender]];
    }

```

---

### 具体代码

> 大致功能已经实现 不做太详细太深入的设计

```solidity
//合约地址:0x01f4E0c6D43f1bEAf545f70de32b28D7Ab7F80d2
//部署人：0x3a284942f74F96a4efFcCEaf4C294A36F70E3712
pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ERC20_G12 is IERC20 {

    //  以下的代币性质皆可用构造器初始化 但是是小组作业 没硬性要求 就直接初始化了
    string public constant name = "Drink_G12";//代币名称
    string public constant symbol = "DR12";//代币符号 类似于￥ $
    uint8 public constant decimals = 2;//精确到小数点后两位
    uint256 totalSupply_ = 1000000;//总共代币数量：一万个币  相当于一千
    address zhou = 0x3a284942f74F96a4efFcCEaf4C294A36F70E3712;


    mapping(address => uint256) balances;//用地址查询余额的映射
    mapping(address => mapping (address => uint256)) allowed;//用地址查询前一个映射：arr1给arr2了多少钱批准


   constructor() {
    balances[zhou] = totalSupply_;
    }

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

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}



contract Drink_Buy is ERC20_G12{

    // address constant DrinkBuy = ;
    address constant OwnerDrink = 0x3a284942f74F96a4efFcCEaf4C294A36F70E3712;

    mapping(string => uint) DrinkNN;//饮料名字 数量
    mapping(string => uint) DrinkNP;//饮料名字 价格
    mapping(address => string) BuyerName;//购买饮料名字
    mapping(address => mapping(string => uint)) BuyerDrink;//购买饮料名字和购买数量
    mapping(address => uint) Point;//积分系统，每买一瓶水 就积一分 满了10分就可以兑换一个鸡蛋
    mapping(address => uint) egg;//兑换的鸡蛋
    
   event _drinkBuy(address buyer,string drinkname,uint num);//购买者购买的名字和数量


    string maiDong="maiDong";
    string wangLaoJi = "wangLaoJi";
    string lvCha = "lvCha";
    string hongCha = "hongCha";
    string xianChengZhi = "xianChengZhi";
    string yiBao = "yiBao";
    string yingYangKuaiXian = "yingYangKuaiXian";

constructor() {
    DrinkNN[maiDong]=100;
    DrinkNN[wangLaoJi]=100;
    DrinkNN[lvCha]=100;
    DrinkNN[hongCha]=100;
    DrinkNN[xianChengZhi]=100;
    DrinkNN[yiBao]=100;
    DrinkNN[yingYangKuaiXian]=100;


    DrinkNP[maiDong]=40;
    DrinkNP[wangLaoJi]=30;
    DrinkNP[lvCha]=30;
    DrinkNP[hongCha]=30;
    DrinkNP[xianChengZhi]=20;
    DrinkNP[yiBao]=10;
    DrinkNP[yingYangKuaiXian]=40;
}
 
    //买水功能
    function _buyDrink(string memory drinkname,uint num) public  returns (bool){
        require(DrinkNN[drinkname]>=num);
        require(balances[msg.sender]>=(num*DrinkNP[drinkname]));
        transfer(OwnerDrink,num*DrinkNP[drinkname]);//这个的调用者是msg.sender
        DrinkNN[drinkname]=DrinkNN[drinkname]-num;
        BuyerName[msg.sender]=drinkname;
        BuyerDrink[msg.sender][drinkname]=num;
        Point[msg.sender]=Point[msg.sender]+num;
        emit _drinkBuy(msg.sender,drinkname,num);
        return true;
    }
    //生产商更新饮料
    function _updateDrink(string memory name,uint price,uint number) public  returns (bool){
        
        require(msg.sender==OwnerDrink);
        DrinkNP[name]=price;
        DrinkNN[name]=number;
        return true;

    }
    //积分兑换
    function PointSwap(uint eggNum)public returns (bool){
        require(Point[msg.sender]>=eggNum*10);
        Point[msg.sender]=Point[msg.sender]-eggNum*10;
        egg[msg.sender]=egg[msg.sender]+eggNum;
        return true;
    }

    //查询饮料剩余
    function calDrinkNum(string memory drinkna) public view returns (uint){
        return DrinkNN[drinkna];
    }
    //查询饮料价格
    function calDrinkPrice(string memory drinkna1) public view returns (uint){
        return DrinkNP[drinkna1];
    }
    
    //查询积分
    function calPoint(address add) public view returns (uint){
        return Point[add];

    }
    //查询鸡蛋
    function calEgg(address add) public view returns (uint){
        return egg[add];
    }
    //查看这个人买了什么
    function calBuyerDrink(address add) public view returns (string memory drinkname,uint drinknumber){
        return (BuyerName[msg.sender],BuyerDrink[msg.sender][BuyerName[msg.sender]]);
        // drinkname=BuyerName[msg.sender];
        // drinknumber=BuyerDrink[msg.sender][BuyerName[msg.sender]];
    }

}
```

---

### 测试截图



![cryptoIntro.png](https://github.com/GOODFLYO/ECR20_Drink/blob/main/img/cryptoIntro.png?raw=true)

---

### 视频演示

> bilibili:https://www.bilibili.com/video/BV1t94y1m7Mq?spm_id_from=333.999.0.0

### BUG

> 本次合约在部署后有一个地方出错了
>
> 本来是要求生产商才能发售的 但是这里合约忘记取消注释了
>
> 因此在使用时 要求调用者不要使用此函数



![bug.png](https://github.com/GOODFLYO/ECR20_Drink/blob/main/img/bug.png?raw=true)



---

## 二、测试教程

### 教程截图

![教程.png](https://github.com/GOODFLYO/ECR20_Drink/blob/main/img/%E6%95%99%E7%A8%8B.png?raw=true)

---

### 部署的合约

> 测试网：https://ropsten.etherscan.io/address/0x01f4E0c6D43f1bEAf545f70de32b28D7Ab7F80d2

---

### 视频教程

> bilibili:https://www.bilibili.com/video/BV1oU4y1y7Ek?spm_id_from=333.999.0.0































