import React, {FC} from "react";
import { Image } from "@chakra-ui/react";

interface NFTprops{
    type: string;
}

const NFT: FC<NFTprops> = ({type}) => {
    return (<Image w = {150} h={150} src={'images/${type}.png'} alt="NFT" />);
};

export default NFT;