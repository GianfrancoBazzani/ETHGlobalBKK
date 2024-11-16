"use client";

import React, { useState } from "react";
import { Button, Label, TextInput } from "flowbite-react";
import { useAccount, useWaitForTransactionReceipt, useWriteContract } from "wagmi";
import { L1BridgeABI } from "../lib/abis/L1BridgeABI";
import { L2BridgeCheckerABI } from "../lib/abis/L2BridgeCheckerABI";


export default function BridgePage() {
    const [l1Token, setL1Token] = useState("");
    const [amount, setAmount] = useState("");
    const [migrationId, setMigrationId] = useState("");
    const { address } = useAccount();

    const { data: txHash, writeContract, isPending } = useWriteContract();
    const { isLoading: isConfirming, isSuccess: isConfirmed } =
        useWaitForTransactionReceipt({ hash: txHash });

    const handleLockFunds = async () => {
        try {
            writeContract({
                address: `0x${process.env.NEXT_PUBLIC_L1_BRIDGE_ADDRESS}`,
                abi: L1BridgeABI,
                functionName: "lockFunds",
                args: [migrationId, amount],
            });
            alert("Tokens locked successfully!");
        } catch (err) {
            console.error(err);
            alert("Failed to lock tokens.");
        }
    };

    const handleUnlockFunds = async () => {
        try {
            writeContract({
                address: `0x${process.env.NEXT_PUBLIC_L1_BRIDGE_ADDRESS}`,
                abi: L2BridgeCheckerABI,
                functionName: "mint",
                args: [l1Token, address],
            });
            alert("Tokens claimed successfully!");
        } catch (err) {
            console.error(err);
            alert("Failed to lock tokens.");
        }
    };

    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold  text-purple-300">Bridge Tokens</h1>
            <h2 className=" mt-6 font-bold  text-purple-300">
                Lock Tokens in L1
            </h2>
            <div className="flex flex-col gap-4 mt-2">
                <div>
                    <Label
                        className=" text-purple-300 "
                        htmlFor="l1Token"
                        value="L1 Token Address"
                    />
                    <TextInput
                        id="l1Token"
                        value={l1Token}
                        onChange={(e) => setL1Token(e.target.value)}
                    />
                </div>
                <div>
                    <Label
                        className=" text-purple-300 "
                        htmlFor="amount"
                        value="Amount"
                    />
                    <TextInput
                        id="amount"
                        value={amount}
                        onChange={(e) => setAmount(e.target.value)}
                    />
                </div>
                <div>
                    <Label
                        className=" text-purple-300 "
                        htmlFor="migrationId"
                        value="Migration ID"
                    />
                    <TextInput
                        id="migrationId"
                        value={migrationId}
                        onChange={(e) => setMigrationId(e.target.value)}
                    />
                </div>
                <Button onClick={handleLockFunds}>Lock Tokens</Button>
                <h2 className=" mt-6 font-bold  text-purple-300">
                    Claim Tokens Scroll
                </h2>
                <Button onClick={handleUnlockFunds}>Claim Tokens</Button>

            </div>
        </div>
    );
}
