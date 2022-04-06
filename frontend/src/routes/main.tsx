import React, { FC, useState } from "react";
import { Box, Text, Flex, Button } from '@chakra-ui/react';
import { mintNFTContract } from "../web3Config";
import NFT from "../components/NFT";

interface MainProps{
    account: string;
}

const Main: FC<MainProps> = ({account}) => {
    const [newImage, setNewImage] = useState<string>();

    const onClickMint =async () => {
        try{
            if(!account) return;

            const response = await mintNFTContract.methods.mintNFTtoken().send({from:account});

            if(response.status){
                const balanceLength = await mintNFTContract.methods.balanceOf(account).call();

                const NFTtokenID = await mintNFTContract.methods.tokenOfOwnerByIndex(account, parseInt(balanceLength.length,10)-1).call();

                const NFTtype = await mintNFTContract.methods.NFTtypes(NFTtokenID).call();

                setNewImage(NFTtype);
            }
        }   catch (error){
            console.error(error);
        } 
    };

    return ( 
    <Flex w="full" h="100vh" justifyContent="center" alignItems="center" direction="column">
        <Box>
            {newImage ? (
                <NFT type = {newImage}/>
            ) : (
                <Text>LET'S MINT NFT</Text>
            )}
        </Box>
        <Button onClick={onClickMint}>MINT</Button>
    </Flex>
    );
 };
export default Main;