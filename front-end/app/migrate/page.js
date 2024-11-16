"use client";

import React, { useState } from "react"; // Import useState
import { Button } from "flowbite-react";
import { Label, TextInput, RangeSlider } from "flowbite-react";
import { Datepicker } from "flowbite-react";
import { L2BridgeCheckerABI } from "../lib/abis/L2BridgeCheckerABI.js";
// import { useAccount } from "wagmi";
// import { useNetwork } from 'wagmi'
import { usePrepareContractWrite } from "wagmi";

export default function Migrate() {
  // State hooks for inputs
  const [name, setName] = useState("");
  const [symbol, setSymbol] = useState("");

  const { config, error } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_L2_BRIDGE_CHECKER_ADDRESS,
    abi: L2BridgeCheckerABI,
    functionName: "deployBridgedToken",
  });
  const { write } = useContractWrite(config);

  //const deployToken = async () => {
  //  const walletClient = createWalletClient({
  //    chain: chain,
  //    transport: custom(window.ethereum),
  //  })
  //  console.log(walletClient)
  //  console.log(name);
  //  console.log(symbol);
  //};

  return (
    <div className="flex flex-row">
      <div className="flex flex-col mt-2 p-4 gap-4 w-1/2">
        <h2 className="text-2xl font-bold text-purple-300">
          Migration Creation Menu
        </h2>
        {/* To*/}
        <div className="flex flex-col gap-4">
          <div>
            <div className="mb-2 block">
              <Label
                className=" text-purple-300 "
                htmlFor="To"
                value="L1 ERC20 Token Address"
              />
            </div>
            <TextInput id="To" type="text" sizing="md" />
          </div>
        </div>

        {/* Tb*/}
        <div className="flex flex-col gap-4">
          <div>
            <div className="mb-2 block">
              <Label
                className=" text-purple-300 "
                htmlFor="Tb"
                value="Scroll ERC20 Token Address"
              />
            </div>
            <TextInput id="Tb" type="text" sizing="md" />
          </div>
        </div>

        {/* Tr*/}
        <div className="flex flex-col gap-4">
          <div>
            <div className="mb-2 block">
              <Label
                className=" text-purple-300 "
                htmlFor="Tr"
                value="Scroll ERC20 Rewards Token Address"
              />
            </div>
            <TextInput id="Tr" type="text" sizing="md" />
          </div>
        </div>

        {/* Bridge Multiplier*/}
        <div className=" flex flex-row gap-4 w-full  justify-between pr-4 ">
          <div className="mb-1 block  ">
            <Label
              className=" text-purple-300 "
              htmlFor="bridge-multiplier"
              value="Rewards Bridge Multiplier"
            />
          </div>
          <RangeSlider className="" id="bridge-multiplier" /> <div>0.1</div>
        </div>

        {/* Hold Multiplier*/}
        <div className=" flex flex-row gap-4 w-full  justify-between pr-4 ">
          <div className="mb-1 block  ">
            <Label
              className=" text-purple-300 "
              htmlFor="hold-multiplier"
              value="Rewards Hold Multiplier"
            />
          </div>
          <RangeSlider className="" id="hold-multiplier" /> <div>0.1</div>
        </div>

        {/* bridge window*/}
        <div className=" flex flex-row gap-4 w-full  justify-between pr-4 ">
          <div className="mb-1 block  ">
            <Label
              className=" text-purple-300 "
              htmlFor="bridge-window"
              value="Bonus Bridge Window"
            />
          </div>
          <div className="flex flex-row gap-4">
            <Datepicker /> to <Datepicker />
          </div>
        </div>

        {/* Hold window*/}
        <div className=" flex flex-row gap-4 w-full  justify-between pr-4 ">
          <div className="mb-1 block  ">
            <Label
              className=" text-purple-300 "
              htmlFor="hold-window"
              value="Hold Window"
            />
          </div>
          <div className="flex flex-row gap-4">
            <Datepicker /> to <Datepicker />
          </div>
        </div>
        <div className="flex flex-row w-full justify-center">
          <Button color="purple" className="w-fit ">
            Create Migration
          </Button>
        </div>
      </div>
      <div className="flex flex-col mt-2 p-4 gap-4 w-1/2">
        <h2 className="text-2xl font-bold text-purple-300">
          Scroll Token Deployer menu
        </h2>
        <div className="flex flex-col h-full w-full  justify-center content-center items-center gap-4">
          {/* Name*/}
          <div className="flex flex-col gap-4">
            <div>
              <div className="mb-2 block">
                <Label
                  className=" text-purple-300 "
                  htmlFor="Name"
                  value="Name"
                />
              </div>
              <TextInput
                id="name"
                type="text"
                sizing="md"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
          </div>
          {/* Symbol*/}
          <div className="flex flex-col gap-4">
            <div>
              <div className="mb-2 block">
                <Label
                  className=" text-purple-300 "
                  htmlFor="Symbol"
                  value="Symbol"
                />
              </div>
              <TextInput
                id="symbol"
                type="text"
                sizing="md"
                value={symbol}
                onChange={(e) => setSymbol(e.target.value)}
              />
            </div>
          </div>

          <Button
            color="purple"
            className="w-fit"
            disabled={!write}
            onClick={() => write?.()}
          >
            Deploy Token
          </Button>
          <div className="w-full">
            {/* Tb deploy*/}
            <div className="flex flex-col gap-4">
              <div>
                <div className="mb-2 block">
                  <Label
                    className=" text-purple-300 "
                    htmlFor="tb-deploy"
                    value="Scroll Token Address"
                  />
                </div>
                <TextInput disabled id="Tb-deploy" type="text" sizing="md" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
