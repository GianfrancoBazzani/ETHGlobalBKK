"use client";

import React, { useState, useEffect } from "react"; // Import useState
import { Button } from "flowbite-react";
import { Label, TextInput, RangeSlider } from "flowbite-react";
import { Datepicker } from "flowbite-react";
import { L2BridgeCheckerABI } from "../lib/abis/L2BridgeCheckerABI.js";
import { ethers } from "ethers";
import {
  usePrepareContractWrite,
  usePublicClient,
  useWriteContract,
} from "wagmi";

export default function Migrate() {
  const [name, setName] = useState("");
  const [symbol, setSymbol] = useState("");
  const [deployedAddress, setDeployedAddress] = useState("");

  const { data: txHash, writeContract, isPending } = useWriteContract();
  const publicClient = usePublicClient();

  const { isLoading: isConfirming, isSuccess: isConfirmed } =
    useWaitForTransactionReceipt({ txHash });

  useEffect(() => {
    async function handleTransaction() {
      if (!txHash) return;

      console.log("Transaction sent: ", txHash);

      try {
        // Wait for the transaction to be mined
        const receipt = await publicClient.waitForTransactionReceipt({
          hash: txHash,
        });

        console.log("Transaction receipt: ", receipt);

        // Decode logs to get the deployed token address
        const iface = new ethers.utils.Interface(L2BridgeCheckerABI);
        const eventFragment = iface.getEvent("L2TokenDeployed");

        for (const log of receipt.logs) {
          try {
            const decoded = iface.decodeEventLog(
              eventFragment,
              log.data,
              log.topics
            );

            console.log("Decoded Event: ", decoded);
            setDeployedAddress(decoded.l2Token);
            break;
          } catch (err) {
            console.log("Skipping log due to decoding error: ", err.message);
          }
        }
      } catch (error) {
        console.error("Error waiting for transaction: ", error);
      }
    }

    handleTransaction();
  }, [txHash]);

  const { config, error } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_L2_BRIDGE_CHECKER_ADDRESS,
    abi: L2BridgeCheckerABI,
    functionName: "deployBridgedToken",
  });
  const { write } = useContractWrite(config);

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
            onClick={() => {
              console.log("asdfasdf");
              writeContract({
                L2BridgeCheckerABI,
                address: process.env.NEXT_PUBLIC_L2_BRIDGE_ADDRESS,
                functionName: "deployBridgedToken",
                args: [name, symbol],
              });
            }}
          >
            {isPending ? "Confirming..." : "Deploy Token"}
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
                {txHash && <div>Transaction Hash: {txHash}</div>}
                {isConfirming && <div>Waiting for confirmation...</div>}
                {isConfirmed && <div>Transaction confirmed.</div>}
                <TextInput
                  disabled
                  id="Tb-deploy"
                  type="text"
                  value={deployedAddress}
                  sizing="md"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
