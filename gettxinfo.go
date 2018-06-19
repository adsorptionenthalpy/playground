package main

import (
	"context"
	"fmt"
	"log"
	
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
)

func main() {

	conn, err := ethclient.Dial("https://mainnet.infura.io")
	if err != nil {
		log.Fatalf("Whoops something went wrong...", err)
	}
	
	ctx := context.Background()	
	tx, pending, _ := conn.TransactionByHash(ctx, common.HexToHash(0x4fbbd6f6a12c50e5a381cad53c70768817b0d889e4d0697433b1b8fa16a2aee6))
	
	if (!pending) {
		fmt.Println(tx)
	}

}
