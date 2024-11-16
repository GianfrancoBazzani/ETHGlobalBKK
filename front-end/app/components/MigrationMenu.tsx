"use client";

import { Button, Label, RangeSlider, TextInput } from "flowbite-react";
import { Datepicker } from "flowbite-react";

export default function MigrationMenu() {
    return (
        <div className="flex flex-col mt-2 p-4 gap-4 w-2/3 px-16">
            <h2 className="text-2xl font-bold text-purple-300">
                Migration Menu
            </h2>

            {/* To */}
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

            {/* Tb */}
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

            {/* Tr */}
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

            {/* Bridge Multiplier */}
            <div className=" flex flex-row gap-4 w-full justify-between pr-4 ">
                <div className="mb-1 block">
                    <Label
                        className=" text-purple-300 "
                        htmlFor="bridge-multiplier"
                        value="Rewards Bridge Multiplier"
                    />
                </div>
                <RangeSlider className="" id="bridge-multiplier" /> <div>0.1</div>
            </div>

            {/* Hold Multiplier */}
            <div className=" flex flex-row gap-4 w-full justify-between pr-4 ">
                <div className="mb-1 block">
                    <Label
                        className=" text-purple-300 "
                        htmlFor="hold-multiplier"
                        value="Rewards Hold Multiplier"
                    />
                </div>
                <RangeSlider className="" id="hold-multiplier" /> <div>0.1</div>
            </div>

            {/* Bridge window */}
            <div className=" flex flex-row gap-4 w-full justify-between pr-4 ">
                <div className="mb-1 block">
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

            {/* Hold window */}
            <div className=" flex flex-row gap-4 w-full justify-between pr-4 ">
                <div className="mb-1 block">
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

            {/* Submit Button */}
            <div className="flex flex-row w-full justify-center">
                <Button color="purple" className="w-fit">
                    Create Migration
                </Button>
            </div>
        </div>
    );
}
