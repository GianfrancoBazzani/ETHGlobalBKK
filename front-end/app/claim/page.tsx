"use client";

import { Button } from "flowbite-react";
import { TextInput } from "flowbite-react";

export default function BridgePage() {
    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold  text-purple-300">
                Rewards Distribution
            </h1>
            <div className=" flex flex-row gap-2">
                <div className="flex flex-col mt-2 p-4 gap-4 w-1/3 text-center items-center">
                    <h2 className="text-purple-300">Long-term Program Allocation</h2>
                    <div className="flex flex-col gap-4">
                        <div>
                            <div className="mb-2 block"></div>
                            <TextInput disabled id="name" type="text" sizing="md" />
                        </div>
                    </div>
                    <Button color="purple" className="w-fit">
                        Check Allocation
                    </Button>
                </div>
                <div className="flex flex-col mt-2 p-4 gap-4 w-1/3 text-center items-center">
                    <h2 className="text-purple-300"> Early Migrator Allocation</h2>
                    <div className="flex flex-col gap-4">
                        <div>
                            <div className="mb-2 block"></div>
                            <TextInput disabled id="name" type="text" sizing="md" />
                        </div>
                    </div>
                    <Button color="purple" className="w-fit">
                        Check Allocation
                    </Button>
                </div>
                <div className="flex flex-col mt-2 p-4 gap-4 w-1/3 text-center items-center">
                    <h2 className="text-purple-300"> Total Amount Bridged</h2>
                    <div className="flex flex-col gap-4">
                        <div>
                            <div className="mb-2 block"></div>
                            <TextInput disabled id="name" type="text" sizing="md" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
