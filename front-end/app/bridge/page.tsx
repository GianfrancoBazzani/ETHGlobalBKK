"use client";

import React, { useState } from "react";
import { Button, Label, TextInput } from "flowbite-react";
import { useWriteContract } from "wagmi";
import { L1BridgeABI } from "../lib/abis/L1BridgeABI";

export default function BridgePage() {
    const [l1Token, setL1Token] = useState("");
    const [amount, setAmount] = useState("");
    const [migrationId, setMigrationId] = useState("");

    const { writeContract } = useWriteContract();

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

    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold">Bridge Tokens</h1>
            <div className="flex flex-col gap-4 mt-4">
                <div>
                    <Label htmlFor="l1Token" value="L1 Token Address" />
                    <TextInput id="l1Token" value={l1Token} onChange={(e) => setL1Token(e.target.value)} />
                </div>
                <div>
                    <Label htmlFor="amount" value="Amount" />
                    <TextInput id="amount" value={amount} onChange={(e) => setAmount(e.target.value)} />
                </div>
                <div>
                    <Label htmlFor="migrationId" value="Migration ID" />
                    <TextInput id="migrationId" value={migrationId} onChange={(e) => setMigrationId(e.target.value)} />
                </div>
                <Button onClick={handleLockFunds}>Lock Tokens</Button>
            </div>
        </div>
    );
}
